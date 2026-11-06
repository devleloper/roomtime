import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/custom_bounce_button.dart';

enum GlassButtonStyle { primary, secondary, destructive }

class GlassDialogButton extends StatelessWidget {
  static const _labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const _horizontalPadding = 12.0;

  final String label;
  final VoidCallback? onPressed;
  final GlassButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool autofocus;

  const GlassDialogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = GlassButtonStyle.secondary,
    this.icon,
    this.isLoading = false,
    this.autofocus = false,
  });

  double minWidthForWords(TextScaler textScaler) {
    var widest = 0.0;
    for (final word in label.split(RegExp(r'\s+'))) {
      final painter = TextPainter(
        text: TextSpan(text: word, style: _labelStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      if (painter.width > widest) {
        widest = painter.width;
      }
      painter.dispose();
    }
    final leading = icon != null || isLoading ? 20 + 8 : 0;
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

class GlassButtonRow extends StatelessWidget {
  static const _gap = 16.0;

  final List<Widget> children;

  const GlassButtonRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final largeText = textScaler.scale(16) > 24;
    if (largeText || children.length > 2) {
      return _column(reversed: largeText);
    }

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

  Widget _column({required bool reversed}) {
    return Column(
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
}
