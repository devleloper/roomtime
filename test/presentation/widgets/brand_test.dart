import 'dart:io';

import 'package:roomtime/presentation/theme/app_palette.dart';
import 'package:roomtime/presentation/theme/app_theme.dart';
import 'package:roomtime/presentation/theme/app_typography.dart';
import 'package:roomtime/presentation/widgets/room_time_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pump(
  WidgetTester tester,
  Widget child, {
  ThemeData? theme,
  double textScale = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.dark,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
  // MaterialApp animates theme changes; settle so brightness is final.
  await tester.pumpAndSettle();
}

void main() {
  group('RoomTimeLogo', () {
    testWidgets('mark announces the brand once, as an image', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, const RoomTimeLogo());
      expect(
        tester.getSemantics(find.byType(RoomTimeLogo)),
        matchesSemantics(label: 'RoomTime', isImage: true),
      );
      expect(
        tester.getSize(
          find.descendant(
            of: find.byType(RoomTimeLogo),
            matching: find.byType(CustomPaint),
          ),
        ),
        const Size(48, 48),
      );
      handle.dispose();
    });

    testWidgets('decorative when the label is null', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(
        tester,
        const RoomTimeLogo(showWordmark: true, semanticLabel: null),
      );
      expect(find.bySemanticsLabel('RoomTime'), findsNothing);
      handle.dispose();
    });

    testWidgets('lockup keeps its size at 200 % text (the logo is an image)', (
      tester,
    ) async {
      await pump(tester, const RoomTimeLogo(showWordmark: true, size: 64));
      final normal = tester.getSize(find.byType(RoomTimeLogo));
      await pump(
        tester,
        const RoomTimeLogo(showWordmark: true, size: 64),
        textScale: 2,
      );
      expect(tester.getSize(find.byType(RoomTimeLogo)), normal);
      expect(tester.takeException(), isNull);
    });

    testWidgets('wordmark ink follows the background', (tester) async {
      Color ink() => tester.widget<Text>(find.text('RoomTime')).style!.color!;
      await pump(
        tester,
        const RoomTimeLogo(showWordmark: true),
        theme: AppTheme.light,
      );
      expect(ink(), AppPalette.ink);
      await pump(
        tester,
        const RoomTimeLogo(showWordmark: true),
        theme: AppTheme.dark,
      );
      expect(ink(), AppPalette.neutral100);
      await pump(
        tester,
        const RoomTimeLogo(showWordmark: true, reversed: true),
        theme: AppTheme.light,
      );
      expect(ink(), AppPalette.neutral100);
    });

    testWidgets('mark blue follows the background', (tester) async {
      Color mark() {
        final paint = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(RoomTimeLogo),
            matching: find.byType(CustomPaint),
          ),
        );
        // ignore: avoid_dynamic_calls
        return (paint.painter! as dynamic).color as Color;
      }

      await pump(tester, const RoomTimeLogo(), theme: AppTheme.light);
      expect(mark(), AppPalette.blue55);
      await pump(tester, const RoomTimeLogo(), theme: AppTheme.dark);
      expect(mark(), AppPalette.brandBlue);
      await pump(
        tester,
        const RoomTimeLogo(reversed: true),
        theme: AppTheme.light,
      );
      expect(mark(), AppPalette.neutral100);
    });

    test('painter geometry and colors match the SVG master (option C)', () {
      final svg = File(
        'assets/brand/src/marks/roomtime-mark-c.svg',
      ).readAsStringSync();
      // Same numbers as _MarkPainter._mark in room_time_logo.dart.
      expect(
        svg,
        contains(
          'd="M13 28A6 6 0 0 1 25 28V74H13Z '
          'M31 74V22A52 52 0 0 1 83 74Z"',
        ),
      );
      final build = File('assets/brand/tool/build.py').readAsStringSync();
      expect(build, contains("default='C'"));
      expect(svg, contains('fill-rule="evenodd"'));
      expect(svg, contains('fill="#00AEFF"'));
      expect(AppPalette.brandBlue, const Color(0xFF00AEFF));
      expect(build, contains("BLUE = '#00AEFF'"));
      expect(build, contains("BLUE_55 = '#0083C3'"));
      expect(build, contains("INK = '#001D2F'"));
      expect(AppPalette.blue55, const Color(0xFF0083C3));
      expect(AppPalette.ink, const Color(0xFF001D2F));
    });
  });

  test('font: system on native, bundled Inter on web (VIS-01)', () {
    // Tests run natively: no family, the platform Typography supplies
    // SF Pro / Roboto, like dev-0.1.6.
    expect(AppTypography.fontFamily, isNull);
    expect(AppTheme.dark.textTheme.bodyLarge!.fontFamily, isNot('Inter'));
    final native = AppTypography.textThemeFor(web: false);
    final web = AppTypography.textThemeFor(web: true);
    for (final pair in [
      (native.headlineLarge!, web.headlineLarge!),
      (native.headlineMedium!, web.headlineMedium!),
      (native.titleMedium!, web.titleMedium!),
      (native.bodyLarge!, web.bodyLarge!),
      (native.labelLarge!, web.labelLarge!),
    ]) {
      final (n, w) = pair;
      expect(n.fontFamily, isNull);
      expect(w.fontFamily, AppTypography.webFontFamily);
      // Same sizes, line heights and weights on every platform.
      expect(n.fontSize, w.fontSize);
      expect(n.height, w.height);
      expect(n.fontWeight, w.fontWeight);
    }
    // 0.1.6 hero titles: 34 / 28 bold, tracking -0.5 on both.
    expect(native.headlineLarge!.fontSize, 34);
    expect(native.headlineLarge!.fontWeight, FontWeight.w700);
    expect(native.headlineLarge!.letterSpacing, -0.5);
    expect(native.headlineMedium!.fontSize, 28);
    expect(native.headlineMedium!.letterSpacing, -0.5);
    // System fonts carry their own tracking; Inter's is tuned on web only.
    expect(native.bodyLarge!.letterSpacing, 0);
    expect(web.bodyLarge!.letterSpacing, -0.15);
  });

  test('theme text uses the platform font, colored by the scheme', () {
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      final t = theme.textTheme;
      for (final style in [
        t.displayLarge,
        t.headlineSmall,
        t.titleLarge,
        t.bodyLarge,
        t.bodyMedium,
        t.labelLarge,
        t.labelSmall,
      ]) {
        // Native run: the platform Typography family, never Inter.
        expect(style!.fontFamily, isNot(AppTypography.webFontFamily));
        expect(style.color, isNotNull);
      }
      expect(t.bodyLarge!.color, theme.colorScheme.onSurface);
      expect(t.labelLarge!.fontWeight, FontWeight.w600);
      expect(t.bodyMedium!.fontSize, 14);
      expect(t.bodySmall!.fontSize, greaterThanOrEqualTo(12));
    }
  });
}
