import 'package:roomtime/presentation/features/room/widgets/mission_control_grid.dart';
import 'package:flutter_test/flutter_test.dart';

// UX3-13: 5-6 people on a medium portrait window use 3 x 2.
void main() {
  test('medium portrait: three columns for 5-6 people', () {
    expect(MissionControlGrid.columnsFor(6, 700, 1000), 3);
    expect(MissionControlGrid.columnsFor(5, 600, 960), 3);
  });

  test('compact portrait stays at two columns', () {
    expect(MissionControlGrid.columnsFor(6, 400, 800), 2);
  });

  test('landscape: three columns', () {
    expect(MissionControlGrid.columnsFor(6, 1000, 700), 3);
  });
}
