import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';
import 'media_shortcuts.dart';

/// One round glass control of the dev-0.1.6 call row (`_buildMediaButton`):
/// a [LiquidBounceButton] tinted `surface @ 0.4`, or `#FF453A @ 0.4` when
/// the device is off or the action is destructive. The localized [label]
/// is its accessible name and tooltip; [on] exposes a toggle state.
class MediaControlButton extends StatelessWidget {
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

  /// The microphone toggle of the lobby and the call: red while off, the
  /// tooltip names the shortcut (Ctrl/Cmd+D).
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

  /// The camera toggle of the lobby and the call (Ctrl/Cmd+E).
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

  final IconData icon;
  final String label;
  final String? tooltip;

  /// Null disables the control (dimmed).
  final VoidCallback? onPressed;
  final bool? on;

  /// Off/destructive tint.
  final bool red;
  final double size;
  final FocusNode? focusNode;

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
    if (onPressed != null) return button;
    // Disabled: dimmed, out of the focus order, no tap action for screen
    // readers (F12).
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

/// A centered row of [MediaControlButton]s with the 0.1.6 20 px gaps. In a
/// narrow window the gaps, then the circles, shrink (never below 48 dp).
class MediaControlsRow extends StatelessWidget {
  const MediaControlsRow({super.key, required this.buttons});

  /// Builds each control at the given size.
  final List<Widget Function(double size)> buttons;

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
          if (n * size + gap * (n - 1) <= width) break;
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
