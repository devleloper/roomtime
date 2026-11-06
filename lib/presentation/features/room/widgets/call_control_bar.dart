import 'package:flutter/material.dart';
import 'package:roomtime/core/utils/platform.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/widgets/media_controls.dart';

class CallControlBar extends StatelessWidget {
  final RoomInCall state;
  final bool canSwitchAudioOutput;
  final VoidCallback onToggleMicrophone;
  final VoidCallback onToggleCamera;
  final VoidCallback onFlipCamera;
  final ValueChanged<bool> onToggleSpeakerphone;
  final VoidCallback onLeave;

  const CallControlBar({
    super.key,
    required this.state,
    required this.canSwitchAudioOutput,
    required this.onToggleMicrophone,
    required this.onToggleCamera,
    required this.onFlipCamera,
    required this.onToggleSpeakerphone,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    final call = state.call;
    final mic = call.microphoneEnabled;
    final camera = call.cameraEnabled;
    final speakerOn = call.speakerphoneOn;

    return MediaControlsRow(
      buttons: [
        (size) => MediaControlButton.microphone(
          context,
          on: mic,
          size: size,
          onPressed: onToggleMicrophone,
        ),
        (size) => MediaControlButton.camera(
          context,
          on: camera,
          size: size,
          onPressed: onToggleCamera,
        ),
        if (isTouchPlatform)
          (size) => MediaControlButton(
            icon: Icons.cameraswitch,
            label: context.l10n.roomFlip,
            size: size,
            onPressed: camera ? onFlipCamera : null,
          ),
        if (canSwitchAudioOutput)
          (size) => MediaControlButton(
            icon: speakerOn ? Icons.volume_up : Icons.phone_in_talk,
            label: speakerOn
                ? context.l10n.roomSpeaker
                : context.l10n.roomEarpiece,
            tooltip: speakerOn
                ? context.l10n.roomSwitchToEarpiece
                : context.l10n.roomSwitchToSpeaker,
            size: size,
            onPressed: () => onToggleSpeakerphone(!speakerOn),
          ),
        (size) => MediaControlButton(
          icon: Icons.call_end,
          label: context.l10n.roomLeave,
          red: true,
          size: size,
          onPressed: onLeave,
        ),
      ],
    );
  }
}
