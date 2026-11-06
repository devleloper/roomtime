import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';

abstract final class AppColorSchemes {
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.brandBlue,
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
}

@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
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

  final Color danger;
  final Color onDanger;

  final Color warningContainer;
  final Color onWarningContainer;

  final Color focusRing;

  final Color videoScrim;
  final Color onVideoScrim;

  final Color videoGlass;

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

  static AppSemanticColors of(BuildContext context) {
    return Theme.of(context).extension<AppSemanticColors>() ?? dark;
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
