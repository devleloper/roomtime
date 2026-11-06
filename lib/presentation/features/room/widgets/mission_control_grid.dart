import 'package:flutter/material.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

class MissionControlGrid extends StatelessWidget {
  static const _spacing = AppSpacing.sm;

  static const minTileWidth = 160.0;

  final List<CallParticipant> participants;
  final Widget Function(BuildContext context, CallParticipant participant)
  tileBuilder;

  const MissionControlGrid({
    super.key,
    required this.participants,
    required this.tileBuilder,
  });

  static int columnsFor(int count, double width, double height) {
    final portrait = height >= width;
    final sizeClass = WindowSizeClass.fromWidth(width);
    if (count <= 2) {
      return portrait ? 1 : count;
    }
    if (count <= 4) {
      return 2;
    }
    if (count <= 6) {
      final threeWide =
          !portrait ||
          (sizeClass == WindowSizeClass.medium &&
              (width - _spacing * 4) / 3 >= minTileWidth);
      return threeWide ? 3 : 2;
    }
    if (sizeClass.isCompact) {
      return portrait ? 2 : 4;
    }
    if (sizeClass == WindowSizeClass.medium) {
      return 3;
    }
    return 4;
  }

  Widget _buildTile(
    BuildContext context, {
    required int index,
    required int count,
    required int columns,
    required int rows,
    required double width,
    required double tileWidth,
    required double tileHeight,
    required Duration duration,
  }) {
    final row = index ~/ columns;
    final column = index % columns;
    final remainder = count % columns;
    final inRow = row == rows - 1 && remainder != 0 ? remainder : columns;
    final rowWidth = inRow * tileWidth + _spacing * (inRow - 1);
    final startX = (width - rowWidth) / 2;
    final participant = participants[index];

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
  }

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }
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
              _buildTile(
                context,
                index: i,
                count: count,
                columns: columns,
                rows: rows,
                width: width,
                tileWidth: tileWidth,
                tileHeight: tileHeight,
                duration: duration,
              ),
          ],
        );
      },
    );
  }
}
