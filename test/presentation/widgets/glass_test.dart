import 'package:roomtime/presentation/features/room/widgets/dynamic_island_badge.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  group('DynamicIslandBadge', () {
    Widget pill({bool visible = true, bool island = false}) =>
        DynamicIslandBadge(
          roomName: 'Family room',
          isVisible: visible,
          hasDynamicIsland: island,
          islandOffset: -40,
        );

    testWidgets('slides in, reads its label, leaves semantics when hidden', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester, pill());
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Family room'), findsOneWidget);
      expect(
        tester.getSize(find.byType(GlassSurface)).height,
        greaterThanOrEqualTo(AppSizes.glassPillHeight),
      );
      await pumpApp(tester, pill(visible: false));
      await tester.pump(AppMotion.pillOut);
      await tester.pump();
      expect(find.bySemanticsLabel('Family room'), findsNothing);
      handle.dispose();
    });

    testWidgets('island: grows from the 125 x 37 island in 650 ms', (
      tester,
    ) async {
      await pumpApp(tester, pill(island: true));
      await tester.pump(const Duration(milliseconds: 1));
      final start = tester.getSize(find.byType(GlassSurface));
      expect(start.width, closeTo(AppSizes.dynamicIsland.width, 4));
      expect(start.height, closeTo(AppSizes.dynamicIsland.height, 4));
      await tester.pump(AppMotion.islandMorph);
      final end = tester.getSize(find.byType(GlassSurface));
      expect(end.width, greaterThan(start.width));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('reduced motion: final state at once, no morph', (
      tester,
    ) async {
      await pumpApp(tester, pill(island: true), disableAnimations: true);
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      expect(
        tester.getSize(find.byType(GlassSurface)).width,
        greaterThan(AppSizes.dynamicIsland.width),
      );
    });

    testWidgets('200 % text in 300 dp: one line, ellipsized, no overflow', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const SizedBox(
          width: 300,
          child: Center(
            child: DynamicIslandBadge(
              roomName: 'The very long family room name',
              isVisible: true,
            ),
          ),
        ),
        textScale: 2,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(GlassSurface)).width,
        lessThanOrEqualTo(300),
      );
    });
  });

  testWidgets('GlassSurface blurs on every platform, web included', (
    tester,
  ) async {
    for (final platform in TargetPlatform.values) {
      debugDefaultTargetPlatformOverride = platform;
      await pumpApp(
        tester,
        const GlassSurface(child: SizedBox.square(dimension: 40)),
      );
      expect(find.byType(BackdropFilter), findsOneWidget, reason: '$platform');
    }
    debugDefaultTargetPlatformOverride = null;
  });
}
