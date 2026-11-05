import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

// The dev-0.1.6 dialog language (`join_room_dialog.dart`): a transparent
// Material dialog holding a LiquidGlassContainer (blur 30, surface @ 0.5,
// border white @ 0.2, radius 24, padding 24), a 24 bold centered title,
// outlined fields (radius 12, white @ 0.2, focused #00AEFF) and a row of
// equal buttons (Cancel white @ 0.1, primary #00AEFF, radius 12, 16 w600).
// Every dialog, sheet and status screen of Home, the lobby and the call is
// drawn with these pieces.

/// Widest dialog panel; 0.1.6 stretched it across an iPad (spec §7).
const double glassDialogMaxWidth = AppSizes.glassDialogMaxWidth;

/// Opens [builder] in the original glass dialog frame.
Future<T?> showGlassDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) => showDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: glassDialogMaxWidth),
      child: GlassPanel(child: Builder(builder: builder)),
    ),
  ),
);

/// The glass panel of the 0.1.6 dialog; scrolls when it does not fit.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.tintAlpha = AppGlass.dialogTintAlpha,
  });

  /// Tint for a panel straight over live video (no veil under it): keeps
  /// white70 text at 4.5:1 over a bright frame.
  static const double overVideoTintAlpha = 0.75;

  final Widget child;

  /// Alpha of the `surface` tint (0.1.6: 0.5 over the veil).
  final double tintAlpha;

  @override
  Widget build(BuildContext context) => LiquidGlassContainer(
    blur: 30,
    backgroundColor: AppColors.surface.withValues(alpha: tintAlpha),
    borderColor: Colors.white.withValues(alpha: 0.2),
    borderRadius: 24,
    child: Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    ),
  );
}

/// Title, content and the button row of a 0.1.6 dialog.
class GlassDialogContent extends StatelessWidget {
  const GlassDialogContent({
    super.key,
    required this.title,
    this.icon,
    this.message,
    this.body = const [],
    this.actions = const [],
  });

  final String title;
  final IconData? icon;
  final String? message;
  final List<Widget> body;

  /// Laid out as equal columns of one row (0.1.6 Cancel / Create).
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (icon != null) ...[
          ExcludeSemantics(child: Icon(icon, size: 48, color: Colors.white70)),
          const SizedBox(height: 16),
        ],
        GlassDialogTitle(title),
        if (message != null) ...[
          const SizedBox(height: 12),
          GlassDialogText(message!, textAlign: TextAlign.center),
        ],
        if (body.isNotEmpty) ...[const SizedBox(height: 24), ...body],
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 32),
          GlassButtonRow(children: actions),
        ],
      ],
    );
  }
}

class GlassDialogTitle extends StatelessWidget {
  const GlassDialogTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

/// Secondary text: white70, 15.
class GlassDialogText extends StatelessWidget {
  const GlassDialogText(this.text, {super.key, this.textAlign, this.style});

  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: textAlign,
    style: const TextStyle(color: Colors.white70, fontSize: 15).merge(style),
  );
}

/// Error line in iOS systemRed (#FF453A), read out when it appears.
///
/// [plated]: for text over live camera video (Home), where the red can drop
/// below 4.5:1 on a bright frame. The line then sits on an opaque
/// black @ 0.9 plate (#FF453A on it: 5.1:1) with an error icon.
class GlassErrorText extends StatelessWidget {
  const GlassErrorText(
    this.text, {
    super.key,
    this.textAlign,
    this.plated = false,
  });

  final String text;
  final TextAlign? textAlign;
  final bool plated;

  @override
  Widget build(BuildContext context) {
    final line = Text(
      text,
      textAlign: textAlign,
      style: const TextStyle(color: AppColors.error, fontSize: 14),
    );
    return Semantics(
      liveRegion: true,
      child: plated
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    const ExcludeSemantics(
                      child: Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: line),
                  ],
                ),
              ),
            )
          : line,
    );
  }
}

/// Equal-width buttons with 16 gaps; stacked when the text is large or a
/// label's longest word does not fit its half (Russian labels broke
/// mid-word, "Скопирова/ть"). Labels then wrap only between words.
class GlassButtonRow extends StatelessWidget {
  const GlassButtonRow({super.key, required this.children});

  final List<Widget> children;

  static const _gap = 16.0;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final largeText = textScaler.scale(16) > 24;
    if (largeText || children.length > 2) return _column(reversed: largeText);
    return LayoutBuilder(
      builder: (context, constraints) {
        final slot =
            (constraints.maxWidth - _gap * (children.length - 1)) /
            children.length;
        final fits = children.every(
          (child) =>
              child is! GlassDialogButton ||
              child.minWidthForWords(textScaler) <= slot,
        );
        if (constraints.hasBoundedWidth && !fits) {
          return _column(reversed: false);
        }
        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: _gap),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }

  /// [reversed]: the primary (last) action on top, for large text.
  Widget _column({required bool reversed}) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < children.length; i++) ...[
        if (i > 0) const SizedBox(height: 12),
        children[reversed ? children.length - 1 - i : i],
      ],
    ],
  );
}

enum GlassButtonStyle { primary, secondary, destructive }

/// The 0.1.6 dialog button: a [CustomBounceButton] over a radius 12 fill.
/// A null [onPressed] disables it (dimmed, announced as disabled).
///
/// [GlassButtonStyle.destructive] (End for everyone, Remove) is the iOS
/// systemRed #FF453A fill with black text and icon: 6.2:1, where white on
/// it is 3.4:1, and clearly apart from the blue primary.
class GlassDialogButton extends StatelessWidget {
  const GlassDialogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = GlassButtonStyle.secondary,
    this.icon,
    this.isLoading = false,
    this.autofocus = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final GlassButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool autofocus;

  static const _labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const _horizontalPadding = 12.0;

  /// The narrowest width at which every word of [label] stays whole.
  double minWidthForWords(TextScaler textScaler) {
    var widest = 0.0;
    for (final word in label.split(RegExp(r'\s+'))) {
      final painter = TextPainter(
        text: TextSpan(text: word, style: _labelStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    final leading = icon != null || isLoading ? 20 + 8 : 0;
    // +2: rounding between this measurement and the laid-out text.
    return widest + leading + _horizontalPadding * 2 + 2;
  }

  @override
  Widget build(BuildContext context) {
    final fill = switch (style) {
      GlassButtonStyle.primary => AppColors.primary,
      GlassButtonStyle.secondary => Colors.white.withValues(
        alpha: AppGlass.secondaryFillAlpha,
      ),
      GlassButtonStyle.destructive => AppColors.error,
    };
    final foreground = style == GlassButtonStyle.destructive
        ? Colors.black
        : Colors.white;
    final enabled = onPressed != null && !isLoading;
    final content = Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: _horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foreground,
              ),
            )
          else if (icon != null)
            Icon(icon, color: foreground, size: 20),
          if (isLoading || icon != null) const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: _labelStyle.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
    if (!enabled) {
      return Semantics(
        button: true,
        enabled: false,
        label: label,
        excludeSemantics: true,
        child: Opacity(opacity: 0.5, child: content),
      );
    }
    return CustomBounceButton(
      onPressed: onPressed!,
      borderRadius: 12,
      semanticLabel: label,
      autofocus: autofocus,
      child: ExcludeSemantics(child: content),
    );
  }
}

/// The 0.1.6 outlined dialog field: label white @ 0.7, border white @
/// [AppGlass.fieldBorderAlpha] (20 %, as in 0.1.6), focused #00AEFF, radius 12, error in #FF453A; [obscure] adds the
/// visibility toggle. Passwords are taken verbatim (no autocorrect).
class GlassTextField extends StatefulWidget {
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

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  bool _visible = false;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );

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
        // Wraps instead of cutting "(optional)" off with large text.
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
                onPressed: () => setState(() => _visible = !_visible),
              )
            : null,
      ),
    );
  }
}

/// A yes/no question in the glass dialog. Focus starts on Cancel; resolves
/// to true only on [confirmLabel].
Future<bool> showGlassConfirm({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required String cancelLabel,
  String? message,
  bool destructive = false,
}) async {
  final result = await showGlassDialog<bool>(
    context: context,
    builder: (context) => GlassDialogContent(
      title: title,
      message: message,
      actions: [
        GlassDialogButton(
          label: cancelLabel,
          autofocus: true,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        GlassDialogButton(
          label: confirmLabel,
          style: destructive
              ? GlassButtonStyle.destructive
              : GlassButtonStyle.primary,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// One choice of [showGlassChoices].
typedef GlassChoice<T> = ({
  String label,
  String? description,
  IconData icon,
  T value,
  bool destructive,
});

/// A list of choices as full-width glass buttons, then Cancel. Null when
/// dismissed.
Future<T?> showGlassChoices<T>({
  required BuildContext context,
  required String title,
  required String cancelLabel,
  required List<GlassChoice<T>> choices,
}) => showGlassDialog<T>(
  context: context,
  builder: (context) => GlassDialogContent(
    title: title,
    body: [
      for (final choice in choices) ...[
        GlassDialogButton(
          label: choice.label,
          icon: choice.icon,
          style: choice.destructive
              ? GlassButtonStyle.destructive
              : GlassButtonStyle.secondary,
          onPressed: () => Navigator.of(context).pop(choice.value),
        ),
        if (choice.description case final description?)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GlassDialogText(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        const SizedBox(height: 12),
      ],
    ],
    actions: [
      GlassDialogButton(
        label: cancelLabel,
        autofocus: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);

/// Full screen status (ended call, join errors): black, with the glass
/// dialog in the middle.
class GlassStatusScreen extends StatelessWidget {
  const GlassStatusScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.actions,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: glassDialogMaxWidth),
              child: GlassPanel(
                child: GlassDialogContent(
                  icon: icon,
                  title: title,
                  message: message,
                  actions: actions,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
