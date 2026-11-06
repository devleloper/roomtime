import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

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
    if (keyboard != _keyboard) {
      setState(() {
        _keyboard = keyboard;
      });
    }
  }

  static OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: AppRadius.lgAll,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final rim = _border(AppColors.surface, 1);
    final focused = _keyboard
        ? _border(AppColors.primary, AppSizes.fieldBorderWidth)
        : rim;
    final error = _border(AppColors.error, AppSizes.fieldBorderWidth);
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
          horizontal: 20 + inset,
          vertical: AppSpacing.lg + inset,
        ),
      ),
    );
  }
}
