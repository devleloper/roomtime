import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';

/// Filled text field of dev-0.1.6 (original API and look): `surface` fill
/// with no visible rim, radius 16, white text, grey hint.
///
/// - Keyboard focus is visible (WCAG 2.4.7): a 2 dp `#00AEFF` border while
///   focused with the keyboard ([FocusHighlightMode.traditional], desktop
///   and web); touch focus keeps the 0.1.6 look (the caret only).
/// - [hintText] is also the accessible name of the field (read by screen
///   readers as its hint, even after typing).
/// - [isPassword]: obscured, and the platform may not alter what is typed:
///   no autocorrect, suggestions, capitalization or smart dashes/quotes
///   (iOS changed typed passwords), no autofill/spell check.
/// - [onSubmitted] runs on Enter / the keyboard action ([textInputAction]),
///   e.g. Enter-to-join.
/// - To reset after a failed attempt call `controller.clear()`; typing
///   then starts from an empty field on every platform.
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _keyboard =
      FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_onHighlightMode);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_onHighlightMode);
    super.dispose();
  }

  void _onHighlightMode(FocusHighlightMode mode) {
    final keyboard = mode == FocusHighlightMode.traditional;
    if (keyboard != _keyboard) setState(() => _keyboard = keyboard);
  }

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: AppRadius.lgAll,
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // The 0.1.6 rim is the fill colour: invisible.
    final rim = _border(AppColors.surface, 1);
    final focused = _keyboard
        ? _border(AppColors.primary, AppSizes.fieldBorderWidth)
        : rim;
    final error = _border(AppColors.error, AppSizes.fieldBorderWidth);
    // The 0.1.6 container added its 2 dp border around the padding; keep
    // the same outer size now that the border is drawn by the decorator.
    const inset = AppSizes.fieldBorderWidth;
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      obscureText: widget.isPassword,
      keyboardType: widget.isPassword
          ? TextInputType.visiblePassword
          : widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      inputFormatters: widget.inputFormatters,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      textCapitalization: TextCapitalization.none,
      smartDashesType: widget.isPassword ? SmartDashesType.disabled : null,
      smartQuotesType: widget.isPassword ? SmartQuotesType.disabled : null,
      style: text.bodyLarge?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: text.bodyLarge?.copyWith(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: rim,
        enabledBorder: rim,
        disabledBorder: rim,
        focusedBorder: focused,
        errorBorder: error,
        focusedErrorBorder: error,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.card + inset,
          vertical: AppSpacing.lg + inset,
        ),
      ),
    );
  }
}
