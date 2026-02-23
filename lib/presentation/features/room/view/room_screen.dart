import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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

class RoomScreen extends StatelessWidget {
  final String roomName;

  const RoomScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RoomBloc>()
        ..add(
          ConnectToRoom(
            roomName: roomName,
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
                  child: _buildMediaControls(context, state),
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
      return _buildFullscreenVideo(state.participants.first);
    }

    // 2 Participants (1-on-1 Call)
    if (state.participants.length == 2) {
      final local = state.room?.localParticipant;
      final remote = state.participants.firstWhereOrNull((p) => p != local);

      return Stack(
        children: [
          if (remote != null) _buildFullscreenVideo(remote),
          if (local != null) DraggablePipView(child: _buildVideoView(local)),
        ],
      );
    }

    // 3+ Participants (Mission Control Grid)
    return _buildMissionControlGrid(context, state);
  }

  Widget _buildFullscreenVideo(Participant participant) {
    return SizedBox.expand(child: _buildVideoView(participant));
  }

  Widget _buildVideoView(Participant participant) {
    final videoTrack =
        participant.videoTrackPublications
                .firstWhereOrNull((p) => p.track != null)
                ?.track
            as VideoTrack?;

    if (videoTrack != null) {
      return VideoTrackRenderer(videoTrack);
    }

    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.person, size: 64, color: Colors.white24),
      ),
    );
  }

  Widget _buildMissionControlGrid(BuildContext context, RoomState state) {
    return MissionControlGrid(
      participants: state.participants,
      activeSpeakers: state.activeSpeakers,
      buildVideoView: (participant, {fit = VideoViewFit.cover}) =>
          _buildVideoView(participant),
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
    return CustomBounceButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color ?? AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
