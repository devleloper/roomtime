import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/presentation/theme/app_theme.dart';
import 'package:roomtime/presentation/theme/app_typography.dart';

void main() {
  test('font: system on native, bundled Inter on web', () {
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
      expect(n.fontSize, w.fontSize);
      expect(n.height, w.height);
      expect(n.fontWeight, w.fontWeight);
    }
    expect(native.headlineLarge!.fontSize, 34);
    expect(native.headlineLarge!.fontWeight, FontWeight.w700);
    expect(native.headlineLarge!.letterSpacing, -0.5);
    expect(native.headlineMedium!.fontSize, 28);
    expect(native.headlineMedium!.letterSpacing, -0.5);
    expect(native.bodyLarge!.letterSpacing, 0);
    expect(web.bodyLarge!.letterSpacing, -0.15);
  });

  test('theme text uses the platform font, colored by the scheme', () {
    final theme = AppTheme.dark;
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
      expect(style!.fontFamily, isNot(AppTypography.webFontFamily));
      expect(style.color, isNotNull);
    }
    expect(t.bodyLarge!.color, theme.colorScheme.onSurface);
    expect(t.labelLarge!.fontWeight, FontWeight.w600);
    expect(t.bodyMedium!.fontSize, 14);
    expect(t.bodySmall!.fontSize, greaterThanOrEqualTo(12));
  });
}
