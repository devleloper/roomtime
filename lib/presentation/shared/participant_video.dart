import 'package:flutter/material.dart';
// Media render exception (see CallSession): SDK video types are used only to
// draw local and remote video.
import 'package:livekit_client/livekit_client.dart'
    show VideoTrack, VideoTrackRenderer, VideoViewFit;

import '../widgets/widgets.dart';

/// Draws an opaque video handle (`CallParticipant.videoTrack`,
/// `MediaPreviewState.videoTrack`), or the avatar placeholder without video.
/// The video is excluded from semantics; the tile describes it.
class ParticipantVideo extends StatelessWidget {
  const ParticipantVideo({
    super.key,
    required this.videoTrack,
    required this.name,
    this.colorSeed,
    this.cover = true,
  });

  final Object? videoTrack;
  final String name;
  final String? colorSeed;

  /// Fill the box (crop) instead of letterboxing.
  final bool cover;

  @override
  Widget build(BuildContext context) {
    final track = videoTrack;
    if (track is! VideoTrack) {
      return ExcludeSemantics(
        child: AvatarTilePlaceholder(name: name, colorSeed: colorSeed),
      );
    }
    return ExcludeSemantics(
      child: ColoredBox(
        color: Colors.black,
        child: VideoTrackRenderer(
          track,
          key: ValueKey(track.sid ?? identityHashCode(track)),
          fit: cover ? VideoViewFit.cover : VideoViewFit.contain,
        ),
      ),
    );
  }
}
