import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String webFontFamily = 'Inter';

  static const String? fontFamily = kIsWeb ? webFontFamily : null;

  static final TextTheme textTheme = textThemeFor(web: kIsWeb);

  static TextTheme textThemeFor({required bool web}) {
    TextStyle style(
      double size,
      double lineHeight,
      FontWeight weight,
      double interTracking, {
      double systemTracking = 0,
    }) {
      return TextStyle(
        fontFamily: web ? webFontFamily : null,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        letterSpacing: web ? interTracking : systemTracking,
        leadingDistribution: TextLeadingDistribution.even,
      );
    }

    return TextTheme(
      displayLarge: style(57, 64, FontWeight.w700, -1.25),
      displayMedium: style(45, 52, FontWeight.w700, -1),
      displaySmall: style(36, 44, FontWeight.w700, -0.8),
      headlineLarge: style(34, 41, FontWeight.w700, -0.5, systemTracking: -0.5),
      headlineMedium: style(
        28,
        34,
        FontWeight.w700,
        -0.5,
        systemTracking: -0.5,
      ),
      headlineSmall: style(24, 32, FontWeight.w600, -0.45),
      titleLarge: style(22, 28, FontWeight.w600, -0.4),
      titleMedium: style(16, 24, FontWeight.w600, -0.15),
      titleSmall: style(14, 20, FontWeight.w600, -0.1),
      bodyLarge: style(16, 24, FontWeight.w400, -0.15),
      bodyMedium: style(14, 20, FontWeight.w400, -0.1),
      bodySmall: style(12, 16, FontWeight.w400, 0),
      labelLarge: style(14, 20, FontWeight.w600, -0.1),
      labelMedium: style(12, 16, FontWeight.w600, 0),
      labelSmall: style(11, 16, FontWeight.w600, 0.05),
    );
  }
}
