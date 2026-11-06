import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

const double text = 4.5;
const double ui = 3.0;

typedef Pair = (String name, Color fg, Color bg, double min);

List<Pair> schemePairs(ColorScheme s, AppSemanticColors x) => [
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

  test('pinned contrast ratios for primary button and glass borders', () {
    const s = AppColorSchemes.dark;
    expect(contrast(s.onPrimary, s.primary), closeTo(2.47, 0.01));
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
    expect(
      contrast(Colors.white, Color.alphaBlend(x.videoScrim, Colors.white)),
      greaterThan(5.7),
    );
    expect(x.videoScrim.a, closeTo(AppGlass.overlayMinAlpha, 0.01));
  });

  test('white glass controls over video stay readable', () {
    const x = AppSemanticColors.dark;
    for (final frame in [Colors.white, Colors.black, AppPalette.brandBlue]) {
      final glass = Color.alphaBlend(x.videoScrim, frame);
      expectPairs([
        ('onVideoScrim on glass over $frame', x.onVideoScrim, glass, text),
      ]);
    }
    expectPairs([
      ('hang-up icon on danger', x.onDanger, x.danger, text),
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

  test('brand anchors', () {
    const s = AppColorSchemes.dark;
    expect(s.primary, AppPalette.brandBlue);
    expect(s.surface, AppColors.surface);
    expect(s.error, AppColors.error);
    expect(contrast(s.onSurface, s.surface), closeTo(16.67, 0.01));
    expect(contrast(s.onSurfaceVariant, s.surface), closeTo(7.18, 0.01));
    expect(contrast(s.primary, s.surface), closeTo(6.75, 0.01));
    expect(contrast(s.error, s.surface), closeTo(4.89, 0.01));
  });
}
