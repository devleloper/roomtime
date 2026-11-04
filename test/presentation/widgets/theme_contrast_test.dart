import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_palette.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.2 contrast ratio of two opaque colors.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

const double text = 4.5; // WCAG 1.4.3, normal text
const double ui = 3.0; // WCAG 1.4.11, components, icons, focus indicators

typedef Pair = (String name, Color fg, Color bg, double min);

List<Pair> schemePairs(ColorScheme s, AppSemanticColors x) => [
  // onPrimary/primary is checked per theme (dark: known debt, see below).
  ('onSurface/surface', s.onSurface, s.surface, text),
  ('onSurfaceVariant/surface', s.onSurfaceVariant, s.surface, text),
  (
    'onSurface/surfaceContainerHighest',
    s.onSurface,
    s.surfaceContainerHighest,
    text,
  ),
  (
    'onSurfaceVariant/surfaceContainerHighest',
    s.onSurfaceVariant,
    s.surfaceContainerHighest,
    text,
  ),
  (
    'onSurfaceVariant/surfaceContainerHigh',
    s.onSurfaceVariant,
    s.surfaceContainerHigh,
    text,
  ),
  (
    'onSurfaceVariant/surfaceContainerLow',
    s.onSurfaceVariant,
    s.surfaceContainerLow,
    text,
  ),
  ('primary/surface (text buttons, links)', s.primary, s.surface, text),
  (
    'primary/surfaceContainerHigh (dialog actions)',
    s.primary,
    s.surfaceContainerHigh,
    text,
  ),
  (
    'onPrimaryContainer/primaryContainer',
    s.onPrimaryContainer,
    s.primaryContainer,
    text,
  ),
  ('onSecondary/secondary', s.onSecondary, s.secondary, text),
  (
    'onSecondaryContainer/secondaryContainer',
    s.onSecondaryContainer,
    s.secondaryContainer,
    text,
  ),
  ('onTertiary/tertiary', s.onTertiary, s.tertiary, text),
  (
    'onTertiaryContainer/tertiaryContainer',
    s.onTertiaryContainer,
    s.tertiaryContainer,
    text,
  ),
  ('error/surface (error text)', s.error, s.surface, text),
  (
    'error/surfaceContainerLow (sheet rows)',
    s.error,
    s.surfaceContainerLow,
    text,
  ),
  ('onError/error', s.onError, s.error, text),
  (
    'onErrorContainer/errorContainer',
    s.onErrorContainer,
    s.errorContainer,
    text,
  ),
  (
    'onInverseSurface/inverseSurface',
    s.onInverseSurface,
    s.inverseSurface,
    text,
  ),
  (
    'inversePrimary/inverseSurface (snackbar action)',
    s.inversePrimary,
    s.inverseSurface,
    text,
  ),
  ('outline/surface (field, outlined button)', s.outline, s.surface, ui),
  ('outline/surfaceContainerHigh', s.outline, s.surfaceContainerHigh, ui),
  (
    'outline/surfaceContainerLow (field fill)',
    s.outline,
    s.surfaceContainerLow,
    ui,
  ),
  ('onDanger/danger', x.onDanger, x.danger, text),
  (
    'onWarningContainer/warningContainer',
    x.onWarningContainer,
    x.warningContainer,
    text,
  ),
  ('focusRing/surface', x.focusRing, s.surface, ui),
  ('focusRing/surfaceContainerHigh', x.focusRing, s.surfaceContainerHigh, ui),
];

void expectPairs(List<Pair> pairs) {
  final failures = <String>[];
  for (final (name, fg, bg, min) in pairs) {
    final ratio = contrast(fg, bg);
    // Printed so the report can quote measured values.
    debugPrint('${ratio.toStringAsFixed(2)}:1  $name (min $min)');
    if (ratio < min) {
      failures.add('$name: ${ratio.toStringAsFixed(2)} < $min');
    }
  }
  expect(failures, isEmpty);
}

void main() {
  test('dark scheme pairs meet WCAG 2.2 AA', () {
    expectPairs(schemePairs(AppColorSchemes.dark, AppSemanticColors.dark));
  });

  test('light scheme pairs meet WCAG 2.2 AA', () {
    const l = AppColorSchemes.light;
    expectPairs([
      ...schemePairs(l, AppSemanticColors.light),
      ('onPrimary/primary', l.onPrimary, l.primary, text),
    ]);
  });

  test('known contrast debt of the dev-0.1.6 look (tokens.md)', () {
    // White labels on #00AEFF (Create Room, Join, dialog primary): the
    // original look, 2.47:1 < 4.5:1 (WCAG 1.4.3). Ink would give
    // 6.98:1. This test pins the value so a change is deliberate.
    const s = AppColorSchemes.dark;
    expect(contrast(s.onPrimary, s.primary), closeTo(2.47, 0.01));
    expect(contrast(AppPalette.ink, s.primary), closeTo(6.98, 0.01));
    // 0.1.6 panel and outlined field rim white 20 % on black: 1.66:1 < 3:1
    // (WCAG 1.4.11). White 45 % would give 4.41:1.
    for (final alpha in [
      AppGlass.dialogBorderAlpha,
      AppGlass.fieldBorderAlpha,
    ]) {
      final rim = Color.alphaBlend(
        s.onSurface.withValues(alpha: alpha),
        Colors.black,
      );
      expect(contrast(rim, Colors.black), closeTo(1.66, 0.02));
    }
    final stronger = Color.alphaBlend(
      s.onSurface.withValues(alpha: 0.45),
      Colors.black,
    );
    expect(contrast(stronger, Colors.black), closeTo(4.41, 0.02));
    // Focus is identifiable: #00AEFF on the field fill.
    expect(contrast(s.primary, s.surface), greaterThanOrEqualTo(ui));
  });

  test('call controls meet contrast in the dark (in-call) theme', () {
    const s = AppColorSchemes.dark;
    const x = AppSemanticColors.dark;
    expectPairs([
      ('icon neutral', s.onSurface, s.surfaceContainerHighest, ui),
      ('icon highlighted', s.onInverseSurface, s.inverseSurface, ui),
      ('icon danger', x.onDanger, x.danger, ui),
    ]);
  });

  test('video scrim keeps text readable over a white or black frame', () {
    const x = AppSemanticColors.dark;
    for (final frame in [Colors.white, Colors.black, AppPalette.brandBlue]) {
      final composited = Color.alphaBlend(x.videoScrim, frame);
      expectPairs([
        ('onVideoScrim over $frame', x.onVideoScrim, composited, text),
      ]);
    }
    // White frame is the worst case: 5.74:1 (glass tint and camera veil).
    expect(
      contrast(Colors.white, Color.alphaBlend(x.videoScrim, Colors.white)),
      greaterThan(5.7),
    );
    expect(x.videoScrim.a, closeTo(AppGlass.overlayMinAlpha, 0.01));
  });

  test('white glass controls over video stay readable (FaceTime style)', () {
    // Glass over video = saturated blur, black tint multiplied in (as dark
    // as srcOver for black), specular rim at the edges only. Centred
    // content sits on the tint; worst case is a pure white frame.
    const x = AppSemanticColors.dark;
    for (final frame in [Colors.white, Colors.black, AppPalette.brandBlue]) {
      final glass = Color.alphaBlend(x.videoScrim, frame);
      expectPairs([
        ('onVideoScrim on glass over $frame', x.onVideoScrim, glass, text),
      ]);
    }
    expectPairs([
      ('hang-up icon on danger', x.onDanger, x.danger, text),
      // Selected (on) control: inverse fill with a dark icon, over video.
      (
        'selected control icon',
        AppColorSchemes.dark.onInverseSurface,
        AppColorSchemes.dark.inverseSurface,
        ui,
      ),
    ]);
  });

  test('avatar palette keeps white initials >= 4.5:1', () {
    expectPairs([
      for (final color in AppPalette.avatar)
        ('white/$color', AppPalette.neutral100, color, text),
    ]);
  });

  test('brand anchors (docs/design/identity.md)', () {
    const s = AppColorSchemes.dark;
    // dev-0.1.6: #00AEFF on #1E1E1E surface, #FF453A errors.
    expect(s.primary, AppPalette.brandBlue);
    expect(s.surface, AppColors.surface);
    expect(s.error, AppColors.error);
    expect(contrast(s.onSurface, s.surface), closeTo(16.67, 0.01));
    expect(contrast(s.onSurfaceVariant, s.surface), closeTo(7.18, 0.01));
    expect(contrast(s.primary, s.surface), closeTo(6.75, 0.01));
    expect(contrast(s.error, s.surface), closeTo(4.89, 0.01));
    const l = AppColorSchemes.light;
    expect(contrast(l.primary, l.surface), closeTo(5.62, 0.01));
    expect(contrast(l.onPrimary, l.primary), closeTo(5.91, 0.01));
  });

  test('logo colors hold on both themes (identity.md, WCAG 1.4.11)', () {
    const blue = AppPalette.brandBlue;
    const dark = AppColorSchemes.dark;
    const light = AppColorSchemes.light;
    expectPairs([
      ('Blue 55 mark on light surface', AppPalette.blue55, light.surface, ui),
      (
        'Blue 55 mark on light surfaceContainerHighest',
        AppPalette.blue55,
        light.surfaceContainerHighest,
        ui,
      ),
      ('Blue mark on dark surface', blue, dark.surface, ui),
      (
        'Blue mark on dark surfaceContainerHighest',
        blue,
        dark.surfaceContainerHighest,
        ui,
      ),
      ('ink wordmark on light surface', AppPalette.ink, light.surface, text),
      (
        'white wordmark on dark surface',
        AppPalette.neutral100,
        dark.surface,
        text,
      ),
    ]);
    // Why the mark is never #00AEFF on light, and the door is never
    // Doorlight inside a blue mark (identity.md, "Color").
    expect(contrast(blue, light.surface), lessThan(ui));
    expect(contrast(AppPalette.doorlight, blue), lessThan(ui));
  });
}
