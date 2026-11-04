import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_effect.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:roomtime/presentation/widgets/initials_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

void main() {
  group('tokens', () {
    test('window size classes follow M3 breakpoints', () {
      expect(WindowSizeClass.fromWidth(320), WindowSizeClass.compact);
      expect(WindowSizeClass.fromWidth(599), WindowSizeClass.compact);
      expect(WindowSizeClass.fromWidth(600), WindowSizeClass.medium);
      expect(WindowSizeClass.fromWidth(839), WindowSizeClass.medium);
      expect(WindowSizeClass.fromWidth(840), WindowSizeClass.expanded);
      expect(WindowSizeClass.fromWidth(1200), WindowSizeClass.large);
      expect(WindowSizeClass.fromWidth(1600), WindowSizeClass.extraLarge);
      expect(WindowSizeClass.large.isAtLeast(WindowSizeClass.expanded), isTrue);
    });

    testWidgets('AppMotion.resolve is zero when animations are disabled', (
      tester,
    ) async {
      late Duration resolved;
      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            resolved = AppMotion.resolve(context, AppMotion.medium);
            return const SizedBox();
          },
        ),
        disableAnimations: true,
      );
      expect(resolved, Duration.zero);
    });
  });

  group('GlassSurface', () {
    testWidgets('blurs on native and raises a too-light tint', (tester) async {
      await pumpApp(
        tester,
        GlassSurface(
          tint: Colors.black.withValues(alpha: 0.2),
          child: const SizedBox.square(dimension: 100),
        ),
      );
      expect(find.byType(BackdropFilter), findsOneWidget);
      final glass = tester.widget<GlassEffect>(find.byType(GlassEffect));
      expect(glass.tint.a, closeTo(AppGlass.panelMinAlpha, 0.01));
    });

    testWidgets('falls back to a near-opaque fill without blur', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const GlassSurface(
          blur: false,
          variant: GlassVariant.overlay,
          child: SizedBox.square(dimension: 100),
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
      final glass = tester.widget<GlassEffect>(find.byType(GlassEffect));
      expect(glass.blurSigma, 0);
      expect(glass.tint.a, closeTo(AppGlass.overlayFallbackMinAlpha, 0.01));
    });

    testWidgets('high contrast disables blur', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(highContrast: true),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: GlassSurface(child: SizedBox.square(dimension: 10)),
          ),
        ),
      );
      expect(find.byType(BackdropFilter), findsNothing);
    });
  });

  group('InitialsAvatar', () {
    test('initials', () {
      expect(InitialsAvatar.initialsOf('Анна Петрова'), 'АП');
      expect(InitialsAvatar.initialsOf('bob'), 'B');
      expect(InitialsAvatar.initialsOf('  mary   jane  watson '), 'MJ');
      expect(InitialsAvatar.initialsOf(''), '?');
    });

    test('color is stable for a seed', () {
      expect(
        InitialsAvatar.colorFor('p_abc'),
        InitialsAvatar.colorFor('p_abc'),
      );
    });

    testWidgets('decorative by default, labelled on request', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester, const InitialsAvatar(name: 'Anna Petrova'));
      expect(find.bySemanticsLabel('AP'), findsNothing);
      await pumpApp(
        tester,
        const InitialsAvatar(name: 'Anna Petrova', semanticLabel: 'Anna'),
      );
      expect(find.bySemanticsLabel('Anna'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('tile placeholder fits small tiles', (tester) async {
      await pumpApp(
        tester,
        const SizedBox(
          width: 90,
          height: 160,
          child: AvatarTilePlaceholder(name: 'Anna'),
        ),
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
