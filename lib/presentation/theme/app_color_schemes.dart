import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Color schemes built from [AppPalette].
///
/// Every role is set explicitly (no `fromSeed`) so contrast is predictable and
/// testable. Ratios: `docs/design/tokens.md`.
abstract final class AppColorSchemes {
  /// The dev-0.1.6 dark look (`ColorScheme.dark(primary: #00AEFF, surface:
  /// #1E1E1E, error: #FF453A)`), with every role set explicitly.
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.brandBlue,
    // White on blue as in 0.1.6 (2.47:1, below WCAG 1.4.3; recorded in
    // tokens.md "Known contrast debt"). AppPalette.ink gives 6.98:1.
    onPrimary: AppPalette.neutral100,
    primaryContainer: AppPalette.blue30,
    onPrimaryContainer: AppPalette.blue90,
    secondary: AppPalette.mist80,
    onSecondary: AppPalette.mist20,
    secondaryContainer: AppPalette.mist30,
    onSecondaryContainer: AppPalette.mist90,
    tertiary: AppPalette.doorlight,
    onTertiary: AppPalette.apricot20,
    tertiaryContainer: AppPalette.apricot30,
    onTertiaryContainer: AppPalette.apricot90,
    error: AppPalette.systemRed,
    onError: AppPalette.neutral0,
    errorContainer: AppPalette.red30,
    onErrorContainer: AppPalette.red90,
    surface: AppPalette.neutral12,
    onSurface: AppPalette.neutral100,
    onSurfaceVariant: AppPalette.neutral67,
    surfaceDim: AppPalette.neutral7,
    surfaceBright: AppPalette.neutral22,
    surfaceContainerLowest: AppPalette.neutral0,
    surfaceContainerLow: AppPalette.neutral7,
    surfaceContainer: AppPalette.neutral12,
    surfaceContainerHigh: AppPalette.neutral16,
    surfaceContainerHighest: AppPalette.neutral20,
    outline: AppPalette.neutral54,
    outlineVariant: AppPalette.neutral27,
    inverseSurface: AppPalette.neutral90,
    onInverseSurface: AppPalette.neutral12,
    inversePrimary: AppPalette.blue40,
    shadow: AppPalette.neutral0,
    scrim: AppPalette.neutral0,
    surfaceTint: Colors.transparent,
  );

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.blue40,
    onPrimary: AppPalette.neutral100,
    primaryContainer: AppPalette.blue90,
    onPrimaryContainer: AppPalette.ink,
    secondary: AppPalette.mist40,
    onSecondary: AppPalette.neutral100,
    secondaryContainer: AppPalette.mist90,
    onSecondaryContainer: AppPalette.mist10,
    tertiary: AppPalette.apricot40,
    onTertiary: AppPalette.neutral100,
    tertiaryContainer: AppPalette.apricot90,
    onTertiaryContainer: AppPalette.apricot10,
    error: AppPalette.red40,
    onError: AppPalette.neutral100,
    errorContainer: AppPalette.red90,
    onErrorContainer: AppPalette.red10,
    surface: AppPalette.slate98,
    onSurface: AppPalette.slate10,
    onSurfaceVariant: AppPalette.slate29,
    surfaceDim: AppPalette.slate88,
    surfaceBright: AppPalette.slate98,
    surfaceContainerLowest: AppPalette.neutral100,
    surfaceContainerLow: AppPalette.slate96,
    surfaceContainer: AppPalette.slate93,
    surfaceContainerHigh: AppPalette.slate90,
    surfaceContainerHighest: AppPalette.slate88,
    outline: AppPalette.slate47,
    outlineVariant: AppPalette.slate79,
    inverseSurface: AppPalette.slate19,
    onInverseSurface: AppPalette.slate95,
    inversePrimary: AppPalette.brandBlue,
    shadow: AppPalette.neutral0,
    scrim: AppPalette.neutral0,
    surfaceTint: Colors.transparent,
  );
}

/// Roles that [ColorScheme] does not have. Read with
/// `AppSemanticColors.of(context)`.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.danger,
    required this.onDanger,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.focusRing,
    required this.videoScrim,
    required this.onVideoScrim,
    required this.videoGlass,
  });

  /// Fill of destructive actions: leave call, end for everyone, remove.
  final Color danger;
  final Color onDanger;

  /// Reconnecting / degraded-connection banner.
  final Color warningContainer;
  final Color onWarningContainer;

  /// Keyboard focus indicator, drawn outside the control with a gap.
  final Color focusRing;

  /// Minimum backdrop for any text or control drawn over video.
  final Color videoScrim;
  final Color onVideoScrim;

  /// Soft white for glass over video (pressed glare base, 20 %). The glass
  /// rim itself is the specular stroke of `GlassEffect`; content on glass
  /// uses [onVideoScrim]. Hang-up uses the opaque [danger] fill.
  final Color videoGlass;

  static const AppSemanticColors dark = AppSemanticColors(
    danger: AppPalette.danger,
    onDanger: AppPalette.neutral100,
    warningContainer: AppPalette.amber25,
    onWarningContainer: AppPalette.amber90,
    focusRing: AppPalette.brandBlue,
    videoScrim: AppPalette.videoScrim,
    onVideoScrim: AppPalette.neutral100,
    videoGlass: AppPalette.videoGlass,
  );

  static const AppSemanticColors light = AppSemanticColors(
    danger: AppPalette.danger,
    onDanger: AppPalette.neutral100,
    warningContainer: AppPalette.amber90,
    onWarningContainer: AppPalette.amber10,
    focusRing: AppPalette.blue40,
    videoScrim: AppPalette.videoScrim,
    onVideoScrim: AppPalette.neutral100,
    videoGlass: AppPalette.videoGlass,
  );

  /// The extension of the ambient theme; falls back to the set matching the
  /// theme brightness when a test or a foreign theme does not register it.
  static AppSemanticColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AppSemanticColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  @override
  AppSemanticColors copyWith({
    Color? danger,
    Color? onDanger,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? focusRing,
    Color? videoScrim,
    Color? onVideoScrim,
    Color? videoGlass,
  }) {
    return AppSemanticColors(
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      focusRing: focusRing ?? this.focusRing,
      videoScrim: videoScrim ?? this.videoScrim,
      onVideoScrim: onVideoScrim ?? this.onVideoScrim,
      videoGlass: videoGlass ?? this.videoGlass,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) {
      return this;
    }
    return AppSemanticColors(
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      videoScrim: Color.lerp(videoScrim, other.videoScrim, t)!,
      onVideoScrim: Color.lerp(onVideoScrim, other.onVideoScrim, t)!,
      videoGlass: Color.lerp(videoGlass, other.videoGlass, t)!,
    );
  }
}
