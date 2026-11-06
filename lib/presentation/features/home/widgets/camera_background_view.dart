import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/participant_video.dart';

class CameraBackgroundView extends StatelessWidget {
  final Object? videoTrack;

  const CameraBackgroundView({super.key, required this.videoTrack});

  @override
  Widget build(BuildContext context) {
    final track = videoTrack;
    return AnimatedSwitcher(
      duration: AppMotion.resolve(context, AppMotion.long),
      child: track == null
          ? const ColoredBox(
              key: ValueKey('placeholder'),
              color: Colors.black,
              child: SizedBox.expand(),
            )
          : SizedBox.expand(
              key: const ValueKey('camera'),
              child: ParticipantVideo(
                videoTrack: track,
                name: context.l10n.appName,
              ),
            ),
    );
  }
}
