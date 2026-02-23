import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class MissionControlGrid extends StatelessWidget {
  final List<Participant> participants;
  final List<Participant> activeSpeakers;
  final Widget Function(Participant, {VideoViewFit fit}) buildVideoView;

  const MissionControlGrid({
    super.key,
    required this.participants,
    required this.activeSpeakers,
    required this.buildVideoView,
  });

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) return const SizedBox.shrink();

    // Mission Control logic: automatically divide the screen space.
    // If the list is <= 4, we can usually do a 2x2 or 1x2 grid.
    // Given the constraints: all videos must fit without scrolling.

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalParticipants = participants.length;
        int activeSpkCount = activeSpeakers
            .where((s) => participants.contains(s))
            .length;

        // Let's create an implicit animation layout.
        // Wrap provides a simple way to fill space, but we want proportional filling.

        int columns;
        int rows;

        if (totalParticipants <= 2) {
          // Fallback, though 1-on-1 is handled elsewhere.
          columns = 1;
          rows = totalParticipants;
        } else if (totalParticipants <= 4) {
          columns = 2;
          rows = (totalParticipants / 2).ceil();
        } else if (totalParticipants <= 6) {
          columns = 3;
          rows = 2;
        } else {
          columns = 3;
          rows = (totalParticipants / 3).ceil();
        }

        // Base width if no active speaker sizing is applied
        final baseWidth = constraints.maxWidth / columns;

        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: participants.map((participant) {
              final isActive = activeSpeakers.contains(participant);

              final activeTrackPub = participant.videoTrackPublications
                  .where((p) => p.track != null)
                  .firstOrNull;

              double aspectRatio = 1.0; // Fallback to square
              if (activeTrackPub != null && activeTrackPub.dimensions != null) {
                final w = activeTrackPub.dimensions!.width;
                final h = activeTrackPub.dimensions!.height;
                if (h > 0 && w > 0) {
                  aspectRatio = w / h;
                }
              }

              // Apply strict boundaries first
              final maxWidthClamp = constraints.maxWidth - 16;
              final maxHeightClamp =
                  (constraints.maxHeight / (rows > 0 ? rows : 1)) - 16;

              // Determine raw dimensions using baseWidth
              double targetWidth = baseWidth;

              if (activeSpkCount > 0) {
                if (isActive) {
                  targetWidth = baseWidth * 1.05;
                } else {
                  targetWidth = baseWidth * 0.95;
                }
              }

              targetWidth -= 16; // apply margins/padding early

              // Calculate ideal height to maintain exactly the video's aspect ratio
              double targetHeight = targetWidth / aspectRatio;

              // If the height exceeds our safe bounds, constrain height and shrink width
              if (targetHeight > maxHeightClamp) {
                targetHeight = maxHeightClamp;
                targetWidth = targetHeight * aspectRatio;
              }

              // Also ensure targetWidth didn't exceed constraints
              if (targetWidth > maxWidthClamp) {
                targetWidth = maxWidthClamp;
                targetHeight = targetWidth / aspectRatio;
              }

              // Final safety clamp for bad aspect ratios
              targetWidth = targetWidth.clamp(100.0, maxWidthClamp);
              targetHeight = targetHeight.clamp(100.0, constraints.maxHeight);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                width: targetWidth,
                height: targetHeight,
                padding: const EdgeInsets.all(4.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? Colors.greenAccent : Colors.transparent,
                      width: isActive ? 4.0 : 0.0,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.greenAccent.withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: buildVideoView(participant, fit: VideoViewFit.cover),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
