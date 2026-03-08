import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'participant_tile.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalParticipants = participants.length;

        int columns;
        int rows;

        if (totalParticipants <= 2) {
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

        final spacing = 8.0;
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final tileWidth =
            (availableWidth - (spacing * (columns + 1))) / columns;
        final tileHeight = (availableHeight - (spacing * (rows + 1))) / rows;

        final children = <Widget>[];

        for (int i = 0; i < totalParticipants; i++) {
          final participant = participants[i];
          final isActive = activeSpeakers.contains(participant);

          final rowIndex = i ~/ columns;
          final colIndex = i % columns;

          // Center the last row if it's not full
          int itemsInThisRow = columns;
          if (rowIndex == rows - 1) {
            final remainder = totalParticipants % columns;
            if (remainder != 0) {
              itemsInThisRow = remainder;
            }
          }

          // Calculate Centered X offset for current row
          final rowWidth =
              (itemsInThisRow * tileWidth) + (spacing * (itemsInThisRow - 1));
          final startX = (availableWidth - rowWidth) / 2;

          final xOffset = startX + (colIndex * (tileWidth + spacing));
          final yOffset = spacing + (rowIndex * (tileHeight + spacing));

          // Physical Spring Animations for grid layout shift
          children.add(
            AnimatedPositioned(
              key: ValueKey(participant.sid),
              duration: const Duration(milliseconds: 650),
              curve: Curves.elasticOut, // Spring physics
              left: xOffset,
              top: yOffset,
              width: tileWidth,
              height: tileHeight,
              child: ParticipantTile(
                participant: participant,
                isActive: isActive,
                child: buildVideoView(participant, fit: VideoViewFit.cover),
              ),
            ),
          );
        }

        return Stack(children: children);
      },
    );
  }
}
