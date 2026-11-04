import 'package:flutter/material.dart';

import '../../../../domain/entities/call_snapshot.dart';
import '../../../theme/theme.dart';

/// Grid of 3+ participants. Tiles are [AnimatedPositioned] keyed by
/// participant id, so joins and leaves reflow instead of jumping; the last
/// row is centered (flows.md §5 "Layout").
class MissionControlGrid extends StatelessWidget {
  const MissionControlGrid({
    super.key,
    required this.participants,
    required this.tileBuilder,
  });

  final List<CallParticipant> participants;
  final Widget Function(BuildContext context, CallParticipant participant)
  tileBuilder;

  static const _spacing = AppSpacing.sm;

  /// Narrowest tile for a three-column portrait grid.
  static const minTileWidth = 160.0;

  /// Columns for [count] tiles in a [width] x [height] box.
  static int columnsFor(int count, double width, double height) {
    final portrait = height >= width;
    final sizeClass = WindowSizeClass.fromWidth(width);
    if (count <= 2) return portrait ? 1 : count;
    if (count <= 4) return 2;
    if (count <= 6) {
      // Medium portrait (tablets, foldables): 3 x 2 when tiles stay usable.
      final threeWide =
          !portrait ||
          (sizeClass == WindowSizeClass.medium &&
              (width - _spacing * 4) / 3 >= minTileWidth);
      return threeWide ? 3 : 2;
    }
    if (sizeClass.isCompact) return portrait ? 2 : 4;
    if (sizeClass == WindowSizeClass.medium) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) return const SizedBox.shrink();
    final duration = AppMotion.resolve(context, AppMotion.gridReflow);

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = participants.length;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final columns = columnsFor(count, width, height);
        final rows = (count / columns).ceil();

        final tileWidth = (width - _spacing * (columns + 1)) / columns;
        final tileHeight = (height - _spacing * (rows + 1)) / rows;

        return Stack(
          children: [
            for (var i = 0; i < count; i++)
              () {
                final row = i ~/ columns;
                final column = i % columns;
                final remainder = count % columns;
                final inRow = row == rows - 1 && remainder != 0
                    ? remainder
                    : columns;
                final rowWidth = inRow * tileWidth + _spacing * (inRow - 1);
                final startX = (width - rowWidth) / 2;
                final participant = participants[i];
                return AnimatedPositioned(
                  key: ValueKey(participant.id),
                  duration: duration,
                  curve: AppMotion.gridReflowCurve,
                  left: startX + column * (tileWidth + _spacing),
                  top: _spacing + row * (tileHeight + _spacing),
                  width: tileWidth,
                  height: tileHeight,
                  child: tileBuilder(context, participant),
                );
              }(),
          ],
        );
      },
    );
  }
}
