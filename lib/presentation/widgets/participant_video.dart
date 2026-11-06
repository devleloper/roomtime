import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart'
    show VideoTrack, VideoTrackRenderer, VideoViewFit;
import 'package:roomtime/presentation/widgets/initials_avatar.dart';

class ParticipantVideo extends StatelessWidget {
  final Object? videoTrack;
  final String name;
  final String? colorSeed;
  final bool cover;

  const ParticipantVideo({
    super.key,
    required this.videoTrack,
    required this.name,
    this.colorSeed,
    this.cover = true,
  });

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
