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
      create: (context) => getIt<RoomBloc>()
        ..add(
          ConnectToRoom(
            roomName: widget.roomName,
            participantName: 'User_${DateTime.now().millisecondsSinceEpoch}',
          ),
        ),
      child: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                _buildVideoLayout(context, state),
                if (state.status == RoomStatus.connecting)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
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
          _buildFullscreenVideo(state.participants.first),
          _buildTapOverlay(),
        ],
      );
    }

    // 2 Participants (1-on-1 Call)
    if (state.participants.length == 2) {
      final local = state.room?.localParticipant;
      final remote = state.participants.firstWhereOrNull((p) => p != local);

      return Stack(
        children: [
          if (remote != null)
            InteractiveViewer(
              clipBehavior: Clip.none,
              panEnabled: false,
              minScale: 1.0,
              maxScale: 4.0,
              child: _buildFullscreenVideo(remote),
            ),
          _buildTapOverlay(), // Placed UNDER PiP so PiP dragging works
          if (local != null)
            DraggablePipView(
              child: _buildVideoView(local, fit: VideoViewFit.cover),
            ),
        ],
      );
    }

    // 3+ Participants (Mission Control Grid)
    return Stack(
      children: [_buildMissionControlGrid(context, state), _buildTapOverlay()],
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

  Widget _buildFullscreenVideo(Participant participant) {
    return SizedBox.expand(child: _buildVideoView(participant));
  }

  Widget _buildVideoView(
    Participant participant, {
    VideoViewFit fit = VideoViewFit.contain,
  }) {
    final videoTrack =
        participant.videoTrackPublications
                .firstWhereOrNull((p) => p.track != null && !p.muted)
                ?.track
            as VideoTrack?;

    final isMicMuted = !participant.isMicrophoneEnabled();

    Widget content;
    if (videoTrack != null) {
      content = VideoTrackRenderer(videoTrack, fit: fit);
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

    return Stack(
      fit: StackFit.expand,
      children: [
        videoContent,
        if (isMicMuted)
          Positioned(
            bottom: 12,
            right: 12,
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
          context.read<RoomBloc>().add(DisconnectRoom());
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
