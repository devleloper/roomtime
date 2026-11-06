import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';

const double glassDialogMaxWidth = AppSizes.glassDialogMaxWidth;

Future<T?> showGlassDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
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
}

class GlassDialogContent extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? message;
  final List<Widget> body;
  final List<Widget> actions;

  const GlassDialogContent({
    super.key,
    required this.title,
    this.icon,
    this.message,
    this.body = const [],
    this.actions = const [],
  });

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
  final String text;

  const GlassDialogTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
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
}

class GlassDialogText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? style;

  const GlassDialogText(this.text, {super.key, this.textAlign, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: const TextStyle(color: Colors.white70, fontSize: 15).merge(style),
    );
  }
}

class GlassErrorText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final bool plated;

  const GlassErrorText(
    this.text, {
    super.key,
    this.textAlign,
    this.plated = false,
  });

  @override
  Widget build(BuildContext context) {
    final line = Text(
      text,
      textAlign: textAlign,
      style: const TextStyle(color: AppColors.error, fontSize: 14),
    );
    if (!plated) {
      return Semantics(liveRegion: true, child: line);
    }

    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
      ),
    );
  }
}

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

typedef GlassChoice<T> = ({
  String label,
  String? description,
  IconData icon,
  T value,
  bool destructive,
});

Future<T?> showGlassChoices<T>({
  required BuildContext context,
  required String title,
  required String cancelLabel,
  required List<GlassChoice<T>> choices,
}) {
  return showGlassDialog<T>(
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
}

class GlassStatusScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final List<Widget> actions;

  const GlassStatusScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.actions,
    this.message,
  });

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
