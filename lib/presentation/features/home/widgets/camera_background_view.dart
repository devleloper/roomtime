import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../shared/participant_video.dart';
import '../../../theme/theme.dart';

/// Full-bleed front camera behind Home (dev-0.1.6): black until a track is
/// given, then a 500 ms crossfade to the live feed. The screen owns the
/// camera (`MediaPreview`); this only draws it.
class CameraBackgroundView extends StatelessWidget {
  const CameraBackgroundView({super.key, required this.videoTrack});

  /// Opaque video handle (`MediaPreviewState.videoTrack`); null is black.
  final Object? videoTrack;

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
