import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    return _build(AppColorSchemes.dark, AppSemanticColors.dark);
  }

  static Color _resolveLabelColor(Set<WidgetState> states, ColorScheme scheme) {
    if (states.contains(WidgetState.error)) {
      return scheme.error;
    }
    if (states.contains(WidgetState.focused)) {
      return scheme.primary;
    }
    return scheme.onSurface.withValues(alpha: AppGlass.labelAlpha);
  }

  static ThemeData _build(ColorScheme scheme, AppSemanticColors semantic) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [semantic],
    );
    final text = base.textTheme;

    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    );
    const buttonMinSize = Size(AppSizes.minTarget, AppSizes.minTarget);
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
    final buttonText = text.titleMedium;
    final rim = scheme.onSurface.withValues(alpha: AppGlass.dialogBorderAlpha);
    final subtleRim = scheme.onSurface.withValues(alpha: AppGlass.borderAlpha);
    final fieldRim = scheme.onSurface.withValues(
      alpha: AppGlass.fieldBorderAlpha,
    );

    OutlineInputBorder inputBorder(Color color) {
      return OutlineInputBorder(
        borderRadius: AppRadius.mdAll,
        borderSide: BorderSide(color: color),
      );
    }

    return base.copyWith(
      scaffoldBackgroundColor: scheme.scrim,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.scrim,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        labelStyle: text.bodyLarge?.copyWith(
          color: scheme.onSurface.withValues(alpha: AppGlass.labelAlpha),
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          return text.bodyLarge!.copyWith(
            color: _resolveLabelColor(states, scheme),
          );
        }),
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
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
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
        backgroundColor: scheme.surface,
        modalBackgroundColor: scheme.surface,
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
        backgroundColor: scheme.surface,
        contentTextStyle: text.bodyMedium?.copyWith(color: scheme.onSurface),
        actionTextColor: scheme.primary,
        elevation: AppElevation.level0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: subtleRim),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: AppRadius.smAll,
          border: Border.all(color: subtleRim),
        ),
        textStyle: text.bodySmall?.copyWith(color: scheme.onSurface),
        waitDuration: AppMotion.long,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.onSurface.withValues(alpha: AppGlass.subtleBorderAlpha),
        space: 1,
      ),
    );
  }
}
