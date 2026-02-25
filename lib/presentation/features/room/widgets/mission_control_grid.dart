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

        // We need a fallback algorithm that tries to maximize usage of the space
        // while remaining inside constraints.

        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: participants.map((participant) {
              final isActive = activeSpeakers.contains(participant);

              final activeTrackPub = participant.videoTrackPublications
                  .where((p) => p.track != null)
                  .firstOrNull;

              // Extract actual video dimensions from WebRTC track
              double aspectRatio = 16 / 9; // Fallback to landscape by default
              if (activeTrackPub != null && activeTrackPub.dimensions != null) {
                final w = activeTrackPub.dimensions!.width;
                final h = activeTrackPub.dimensions!.height;
                if (h > 0 && w > 0) {
                  aspectRatio = w / h;
                }
              }

              // Compute the maximum available tile bounds (accounting for spacing)
              final maxTileWidth = (constraints.maxWidth / columns) - 8.0;
              final maxTileHeight =
                  (constraints.maxHeight / (rows > 0 ? rows : 1)) - 8.0;

              // Start by attempting to fill the width
              double targetWidth = maxTileWidth;
              double targetHeight = targetWidth / aspectRatio;

              // If filling the width makes it too tall, constrain by height instead
              if (targetHeight > maxTileHeight) {
                targetHeight = maxTileHeight;
                targetWidth = targetHeight * aspectRatio;
              }

              // Active Speaker Inflation System
              if (activeSpkCount > 0) {
                if (isActive) {
                  targetWidth *= 1.05;
                  targetHeight *= 1.05;
                } else {
                  targetWidth *= 0.95;
                  targetHeight *= 0.95;
                }
              }

              // Final clamp to ensure we never break out of the parent LayoutBuilder bounds
              targetWidth = targetWidth.clamp(50.0, constraints.maxWidth - 8.0);
              targetHeight = targetHeight.clamp(
                50.0,
                constraints.maxHeight - 8.0,
              );

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                width: targetWidth,
                height: targetHeight,
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
                    child: buildVideoView(
                      participant,
                      fit: VideoViewFit.contain,
                    ),
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
