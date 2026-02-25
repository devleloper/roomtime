import 'dart:async';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../../core/di/injection.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bounce_button.dart';
import '../widgets/draggable_pip_view.dart';
import '../widgets/mission_control_grid.dart';
import '../bloc/room_bloc.dart';
import '../bloc/room_event.dart';
import '../bloc/room_state.dart';

class RoomScreen extends StatefulWidget {
  final String roomName;

  const RoomScreen({super.key, required this.roomName});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  Timer? _hideTimer;
  Participant? _pinnedParticipant;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      _startHideTimer();
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<RoomBloc>();
        // Delay heavy C++ WebRTC connection logic to allow route push transition (300ms) to complete
        Future.delayed(const Duration(milliseconds: 350), () {
          if (!bloc.isClosed) {
            bloc.add(
              ConnectToRoom(
                roomName: widget.roomName,
                participantName:
                    'User_${DateTime.now().millisecondsSinceEpoch}',
              ),
            );
          }
        });
        return bloc;
      },
      child: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                if (state.status == RoomStatus.connecting)
                  Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else
                  _buildVideoLayout(context, state),
                if (state.status == RoomStatus.error)
                  Center(
                    child: Text(
                      state.errorMessage ?? 'Error connecting',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: AnimatedSlide(
                    offset: _showControls ? Offset.zero : const Offset(0, 1.5),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: !_showControls,
                        child: _buildMediaControls(context, state),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoLayout(BuildContext context, RoomState state) {
    if (state.participants.isEmpty) return const SizedBox.shrink();

    // 1 Participant (Only Local)
    if (state.participants.length == 1) {
      return Stack(
        children: [
          _buildFullscreenVideo(
            state.participants.first,
            fit: VideoViewFit.cover,
            showMicIcon: false,
          ),
          _buildTapOverlay(),
        ],
      );
    }

    // 2 Participants (1-on-1 Call)
    if (state.participants.length == 2) {
      final local = state.room?.localParticipant;
      final remote = state.participants.firstWhereOrNull((p) => p != local);

      Participant fullscreenParticipant = remote ?? state.participants.first;
      Participant pipParticipant = local ?? state.participants.last;

      if (_pinnedParticipant != null &&
          state.participants.contains(_pinnedParticipant)) {
        fullscreenParticipant = _pinnedParticipant!;
        pipParticipant = state.participants.firstWhere(
          (p) => p != _pinnedParticipant,
        );
      }

      final isLocalFullscreen = fullscreenParticipant == local;
      final fullscreenFit = isLocalFullscreen
          ? VideoViewFit.cover
          : VideoViewFit.contain;

      return Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: _buildSwapTransition,
            child: InteractiveViewer(
              key: ValueKey(fullscreenParticipant.sid),
              clipBehavior: Clip.none,
              panEnabled: false,
              minScale: 1.0,
              maxScale: 4.0,
              child: _buildFullscreenVideo(
                fullscreenParticipant,
                fit: fullscreenFit,
                showMicIcon: !isLocalFullscreen,
              ),
            ),
          ),
          _buildTapOverlay(), // Placed UNDER PiP so PiP dragging works
          DraggablePipView(
            onTap: () {
              setState(() {
                _pinnedParticipant = pipParticipant;
              });
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: _buildSwapTransition,
              child: _buildVideoView(
                pipParticipant,
                key: ValueKey(pipParticipant.sid),
                fit: VideoViewFit.cover,
              ),
            ),
          ),
        ],
      );
    }

    // 3+ Participants (Mission Control Grid)
    return Stack(
      children: [_buildMissionControlGrid(context, state), _buildTapOverlay()],
    );
  }

  Widget _buildSwapTransition(Widget child, Animation<double> animation) {
    final scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }

  Widget _buildTapOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _toggleControls,
        // Also absorb dual touch scale events completely when not intended for InteractiveViewer
      ),
    );
  }

  Widget _buildFullscreenVideo(
    Participant participant, {
    VideoViewFit fit = VideoViewFit.contain,
    bool showMicIcon = true,
  }) {
    return SizedBox.expand(
      child: _buildVideoView(participant, fit: fit, showMicIcon: showMicIcon),
    );
  }

  Widget _buildVideoView(
    Participant participant, {
    Key? key,
    VideoViewFit fit = VideoViewFit.contain,
    bool showMicIcon = true,
  }) {
    final videoTrack =
        participant.videoTrackPublications
                .firstWhereOrNull((p) => p.track != null && !p.muted)
                ?.track
            as VideoTrack?;

    final isMicMuted = !participant.isMicrophoneEnabled();

    Widget content;
    if (videoTrack != null) {
      content = VideoTrackRenderer(
        videoTrack,
        fit: fit,
        key: ValueKey('${participant.sid}_${videoTrack.sid}'),
      );
    } else {
      content = Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.videocam_off, size: 64, color: Colors.white24),
        ),
      );
    }

    Widget videoContent = content;

    if (participant is LocalParticipant) {
      videoContent = BlocBuilder<RoomBloc, RoomState>(
        buildWhen: (prev, curr) => prev.isFrontCamera != curr.isFrontCamera,
        builder: (context, state) {
          return _CameraFlipWidget(
            isFrontCamera: state.isFrontCamera,
            child: content,
          );
        },
      );
    }

    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        final screenAR = constraints.maxWidth / constraints.maxHeight;

        // Extract native video aspect ratio
        double videoAR = 1.0;
        bool hasVideo =
            videoTrack != null && participant.videoTrackPublications.isNotEmpty;
        if (hasVideo) {
          final pub = participant.videoTrackPublications.firstWhereOrNull(
            (p) => p.track == videoTrack,
          );
          if (pub != null && pub.dimensions != null) {
            final w = pub.dimensions!.width;
            final h = pub.dimensions!.height;
            if (h > 0 && w > 0) videoAR = w / h;
          }
        }

        // Calculate letterboxing based on fit
        double renderedWidth = constraints.maxWidth;
        double renderedHeight = constraints.maxHeight;

        if (fit == VideoViewFit.contain && hasVideo) {
          if (screenAR > videoAR) {
            // Screen is wider than video (pillarboxing on sides)
            renderedWidth = constraints.maxHeight * videoAR;
          } else {
            // Screen is taller than video (letterboxing on top/bottom)
            renderedHeight = constraints.maxWidth / videoAR;
          }
        }

        final horizontalPadding = (constraints.maxWidth - renderedWidth) / 2;
        final verticalPadding = (constraints.maxHeight - renderedHeight) / 2;

        return Stack(
          fit: StackFit.expand,
          children: [
            videoContent,
            if (isMicMuted && showMicIcon)
              Positioned(
                bottom: verticalPadding + 12,
                right: horizontalPadding + 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.mic_off,
                        size: 20,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMissionControlGrid(BuildContext context, RoomState state) {
    return MissionControlGrid(
      participants: state.participants,
      activeSpeakers: state.activeSpeakers,
      buildVideoView: (participant, {fit = VideoViewFit.cover}) =>
          _buildVideoView(participant, fit: fit),
    );
  }

  Widget _buildMediaControls(BuildContext context, RoomState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMediaButton(
          state.isMicEnabled ? Icons.mic : Icons.mic_off,
          () => context.read<RoomBloc>().add(
            ToggleMicrophone(!state.isMicEnabled),
          ),
          color: state.isMicEnabled ? AppColors.surface : AppColors.error,
        ),
        const SizedBox(width: 20),
        _buildMediaButton(
          state.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
          () => context.read<RoomBloc>().add(
            ToggleCamera(!state.isCameraEnabled),
          ),
          color: state.isCameraEnabled ? AppColors.surface : AppColors.error,
        ),
        const SizedBox(width: 20),
        _buildMediaButton(
          Icons.cameraswitch,
          () => context.read<RoomBloc>().add(SwitchCamera()),
        ),
        const SizedBox(width: 20),
        _buildMediaButton(Icons.call_end, () {
          // Immediately disable camera and mic to clear hardware lights/audio instantly
          final bloc = context.read<RoomBloc>();
          bloc.add(ToggleMicrophone(false));
          bloc.add(ToggleCamera(false));

          // BLoC disposes the room asynchronously upon Provider tear-down,
          // instantly pop to avoid transition jank.
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }, color: AppColors.error),
      ],
    );
  }

  Widget _buildMediaButton(
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    final bgColor =
        color?.withValues(alpha: 0.4) ??
        AppColors.surface.withValues(alpha: 0.4);

    return CustomBounceButton(
      onPressed: () {
        _startHideTimer();
        onPressed();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Icon(
                icon,
                key: ValueKey(icon),
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraFlipWidget extends StatefulWidget {
  final Widget child;
  final bool isFrontCamera;

  const _CameraFlipWidget({required this.child, required this.isFrontCamera});

  @override
  State<_CameraFlipWidget> createState() => _CameraFlipWidgetState();
}

class _CameraFlipWidgetState extends State<_CameraFlipWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didUpdateWidget(_CameraFlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFrontCamera != oldWidget.isFrontCamera) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curveValue = Curves.easeInOut.transform(_controller.value);
        final direction = widget.isFrontCamera ? 1.0 : -1.0;
        double angle;

        if (curveValue <= 0.5) {
          // 0.0 to 90.0 degrees
          angle = curveValue * 3.14159265 * direction;
        } else {
          // -90.0 to 0.0 degrees
          angle = (curveValue - 1.0) * 3.14159265 * direction;
        }

        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0015) // Deep perspective
          ..rotateY(angle);

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
