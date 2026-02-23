import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../core/di/injection.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_bounce_button.dart';
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
            body: SafeArea(
              child: Stack(
                children: [
                  _buildVideoGrid(context, state),
                  if (state.status == RoomStatus.connecting)
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
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
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CustomBounceButton(
                      onPressed: () {
                        context.read<RoomBloc>().add(DisconnectRoom());
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoGrid(BuildContext context, RoomState state) {
    if (state.participants.isEmpty) return const SizedBox.shrink();

    // Basic grid logic
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: state.participants.length > 2 ? 2 : 1,
        childAspectRatio: 0.75,
      ),
      itemCount: state.participants.length,
      itemBuilder: (context, index) {
        final participant = state.participants[index];
        final videoTrack =
            participant.videoTrackPublications
                    .firstWhereOrNull((p) => p.track != null)
                    ?.track
                as VideoTrack?;

        if (videoTrack != null) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: VideoTrackRenderer(
                videoTrack,
                fit: BoxFit.cover,
              ), // Render LiveKit VideoTrack
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 64, color: Colors.white24),
            ),
          );
        }
      },
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
          Navigator.of(context).pop();
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
