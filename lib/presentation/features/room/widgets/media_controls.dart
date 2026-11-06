import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/widgets/media_shortcuts.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/widgets/liquid_bounce_button.dart';

class MediaControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? tooltip;

  final VoidCallback? onPressed;
  final bool? on;

  final bool red;
  final double size;
  final FocusNode? focusNode;

  const MediaControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.on,
    this.red = false,
    this.tooltip,
    this.size = 60,
    this.focusNode,
  });

  factory MediaControlButton.microphone(
    BuildContext context, {
    required bool on,
    required VoidCallback? onPressed,
    double size = 60,
  }) {
    final l10n = context.l10n;
    return MediaControlButton(
      icon: on ? Icons.mic : Icons.mic_off,
      label: l10n.roomMic,
      on: on,
      red: !on,
      size: size,
      tooltip: on
          ? l10n.roomMicTurnOff(shortcutLabel('D'))
          : l10n.roomMicTurnOn(shortcutLabel('D')),
      onPressed: onPressed,
    );
  }

  factory MediaControlButton.camera(
    BuildContext context, {
    required bool on,
    required VoidCallback? onPressed,
    double size = 60,
  }) {
    final l10n = context.l10n;
    return MediaControlButton(
      icon: on ? Icons.videocam : Icons.videocam_off,
      label: l10n.roomCamera,
      on: on,
      red: !on,
      size: size,
      tooltip: on
          ? l10n.roomCameraTurnOff(shortcutLabel('E'))
          : l10n.roomCameraTurnOn(shortcutLabel('E')),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tint = (red ? AppColors.error : AppColors.surface).withValues(
      alpha: 0.4,
    );
    final iconSize = size * 28 / 60;
    final button = LiquidBounceButton(
      onPressed: onPressed ?? () {},
      icon: icon,
      bgColor: tint,
      size: size,
      iconSize: iconSize,
      semanticLabel: label,
      tooltip: tooltip,
      toggled: on,
      focusNode: focusNode,
    );
    if (onPressed != null) {
      return button;
    }
    return ExcludeFocus(
      child: Semantics(
        button: true,
        enabled: false,
        label: label,
        excludeSemantics: true,
        child: IgnorePointer(child: Opacity(opacity: 0.5, child: button)),
      ),
    );
  }
}

class MediaControlsRow extends StatelessWidget {
  final List<Widget Function(double size)> buttons;

  const MediaControlsRow({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final n = buttons.length;
        final width = constraints.maxWidth;
        var gap = 20.0;
        var size = 60.0;
        for (final candidate in const [20.0, 12.0, 8.0]) {
          gap = candidate;
          if (n * size + gap * (n - 1) <= width) {
            break;
          }
        }
        if (n * size + gap * (n - 1) > width) {
          size = ((width - gap * (n - 1)) / n).clamp(48.0, 60.0);
        }
        return FocusTraversalGroup(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < n; i++) ...[
                if (i > 0) SizedBox(width: gap),
                buttons[i](size),
              ],
            ],
          ),
        );
      },
    );
  }
}
