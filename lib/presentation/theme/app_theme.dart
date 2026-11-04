import 'package:flutter/material.dart';

import 'app_color_schemes.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// App themes built from tokens. Components use component themes; screens
/// should not restyle Material widgets locally.
///
/// The app is dark-only, like dev-0.1.6 (FaceTime-style chrome over the
/// camera): `MaterialApp(theme: AppTheme.dark, themeMode: ThemeMode.dark)`.
/// [dark] is the 0.1.6 look (black scaffold, #00AEFF, #FF453A, white text,
/// white glass rims) in the platform system font (Inter on web, see
/// [AppTypography]). [light] stays for tests and a possible future light
/// mode.
abstract final class AppTheme {
  static ThemeData get light =>
      _build(AppColorSchemes.light, AppSemanticColors.light);

  static ThemeData get dark =>
      _build(AppColorSchemes.dark, AppSemanticColors.dark);

  /// The dev-0.1.6 name of [dark].
  static ThemeData get darkTheme => dark;

  static ThemeData _build(ColorScheme scheme, AppSemanticColors semantic) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // null on native: the platform Typography picks SF Pro / Roboto.
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme,
      // Desktop defaults to compact density and shrink-wrapped targets
      // (40 dp); keep 48 dp targets everywhere.
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [semantic],
    );
    final text = base.textTheme;
    final dark = scheme.brightness == Brightness.dark;

    // dev-0.1.6 controls: rounded rectangles (12, CTA 16), 16 w600 labels.
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    );
    const buttonMinSize = Size(AppSizes.minTarget, AppSizes.minTarget);
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    final buttonText = text.titleMedium;
    // Glass whites of 0.1.6 (dark only; light keeps M3 outlines).
    final rim = dark
        ? scheme.onSurface.withValues(alpha: AppGlass.dialogBorderAlpha)
        : scheme.outline;
    final subtleRim = dark
        ? scheme.onSurface.withValues(alpha: AppGlass.borderAlpha)
        : scheme.outlineVariant;

    // Text fields: the 0.1.6 resting rim (AppGlass.fieldBorderAlpha).
    final fieldRim = dark
        ? scheme.onSurface.withValues(alpha: AppGlass.fieldBorderAlpha)
        : scheme.outline;

    OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: color),
    );

    return base.copyWith(
      // Dark screens sit on black (camera placeholder, letterboxing), as in
      // 0.1.6; dialogs and sheets are dark glass.
      scaffoldBackgroundColor: dark ? scheme.scrim : scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? scheme.scrim : scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: AppElevation.level0,
        scrolledUnderElevation: AppElevation.level0,
        centerTitle: true,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: buttonText,
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: rim),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: buttonMinSize),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.4),
        selectionHandleColor: scheme.primary,
      ),
      // 0.1.6 dialog fields: outlined, radius 12, blue when focused, label
      // white 70 %, no fill; resting rim white 20 % (AppGlass.fieldBorderAlpha).
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        labelStyle: text.bodyLarge?.copyWith(
          color: scheme.onSurface.withValues(alpha: AppGlass.labelAlpha),
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) => text.bodyLarge!.copyWith(
            color: states.contains(WidgetState.error)
                ? scheme.error
                : states.contains(WidgetState.focused)
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: AppGlass.labelAlpha),
          ),
        ),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        prefixIconColor: scheme.onSurface.withValues(
          alpha: AppGlass.labelAlpha,
        ),
        suffixIconColor: scheme.onSurface.withValues(
          alpha: AppGlass.labelAlpha,
        ),
        helperMaxLines: 3,
        errorMaxLines: 3,
        border: inputBorder(fieldRim),
        enabledBorder: inputBorder(fieldRim),
        focusedBorder: inputBorder(scheme.primary),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error),
        disabledBorder: inputBorder(scheme.onSurface.withValues(alpha: 0.12)),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: AppElevation.level0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      ),
      // Material dialogs and sheets that do not use the glass panel
      // (`dialogs/glass_dialog.dart`) still look like it: dark, radius 24,
      // white rim.
      dialogTheme: DialogThemeData(
        backgroundColor: dark ? scheme.surface : scheme.surfaceContainerHigh,
        elevation: AppElevation.level0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlAll,
          side: BorderSide(color: rim),
        ),
        titleTextStyle: text.headlineSmall?.copyWith(color: scheme.onSurface),
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: dark ? scheme.surface : scheme.surfaceContainerLow,
        modalBackgroundColor: dark
            ? scheme.surface
            : scheme.surfaceContainerLow,
        elevation: AppElevation.level0,
        modalElevation: AppElevation.level0,
        showDragHandle: true,
        dragHandleColor: scheme.onSurfaceVariant,
        constraints: const BoxConstraints(maxWidth: AppSizes.dialogMaxWidth),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
          side: BorderSide(color: subtleRim),
        ),
      ),
      listTileTheme: ListTileThemeData(
        minTileHeight: AppSizes.minTarget + AppSpacing.sm,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.xl,
        ),
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        titleTextStyle: text.titleMedium?.copyWith(color: scheme.onSurface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? scheme.surface : scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: dark ? scheme.onSurface : scheme.onInverseSurface,
        ),
        actionTextColor: dark ? scheme.primary : scheme.inversePrimary,
        elevation: AppElevation.level0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: subtleRim),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: dark ? scheme.surface : scheme.inverseSurface,
          borderRadius: AppRadius.smAll,
          border: dark ? Border.all(color: subtleRim) : null,
        ),
        textStyle: text.bodySmall?.copyWith(
          color: dark ? scheme.onSurface : scheme.onInverseSurface,
        ),
        waitDuration: AppMotion.long,
      ),
      dividerTheme: DividerThemeData(
        // 0.1.6 list separators: white24 / white 10 %.
        color: dark
            ? scheme.onSurface.withValues(alpha: AppGlass.subtleBorderAlpha)
            : scheme.outlineVariant,
        space: 1,
      ),
    );
  }
}
