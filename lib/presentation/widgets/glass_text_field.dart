import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

class GlassTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FocusNode? focusNode;
  final String? errorText;
  final String? helperText;
  final bool obscure;
  final int? maxLength;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.label,
    this.focusNode,
    this.errorText,
    this.helperText,
    this.obscure = false,
    this.maxLength,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _visible = false;

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = widget.obscure;
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      obscureText: password && !_visible,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      textCapitalization: password
          ? TextCapitalization.none
          : widget.textCapitalization,
      keyboardType: password ? TextInputType.visiblePassword : null,
      autocorrect: !password,
      enableSuggestions: !password,
      smartDashesType: password ? SmartDashesType.disabled : null,
      smartQuotesType: password ? SmartQuotesType.disabled : null,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: const TextStyle(color: Colors.white),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        label: Text(widget.label, maxLines: 2, softWrap: true),
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        floatingLabelStyle: TextStyle(
          color: widget.errorText != null
              ? AppColors.error
              : Colors.white.withValues(alpha: 0.7),
        ),
        helperText: widget.helperText,
        helperMaxLines: 3,
        helperStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        counterText: '',
        filled: false,
        enabledBorder: _border(
          Colors.white.withValues(alpha: AppGlass.fieldBorderAlpha),
        ),
        disabledBorder: _border(Colors.white.withValues(alpha: 0.1)),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
        errorText: widget.errorText,
        errorMaxLines: 3,
        errorStyle: const TextStyle(color: AppColors.error),
        suffixIcon: password
            ? IconButton(
                tooltip: _visible
                    ? context.l10n.commonHidePassword
                    : context.l10n.commonShowPassword,
                icon: Icon(
                  _visible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
