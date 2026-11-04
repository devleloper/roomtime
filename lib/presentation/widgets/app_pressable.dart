import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_tokens.dart';

typedef AppPressableBuilder =
    Widget Function(BuildContext context, Set<WidgetState> states);

/// Accessible building block for custom tappable visuals (call controls,
/// video tiles, PiP) and the base of `CustomBounceButton` and
/// `LiquidBounceButton`.
///
/// Provides: focusability and traversal, activation with Enter, Space,
/// Select and gamepad A, click cursor, hover/focus/pressed states for the
/// [builder] (`WidgetState.focused` only while the keyboard focus highlight
/// is visible), button semantics with label and toggled/selected state, and
/// press scale that is skipped when animations are disabled.
class AppPressable extends StatefulWidget {
  const AppPressable({
    super.key,
    required this.onPressed,
    required this.builder,
    this.onLongPress,
    this.semanticLabel,
    this.toggled,
    this.selected,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    this.pressScale = true,
    this.pressedScale = AppMotion.pressedScale,
    this.pressInDuration = AppMotion.pressIn,
  });

  /// Null disables the control (not focusable, semantics `enabled: false`).
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final AppPressableBuilder builder;

  /// Accessible name. When set, descendants' semantics are replaced by it;
  /// when null, text inside [builder] provides the name.
  final String? semanticLabel;

  /// On/off state for toggle controls (mic, camera). Null: not a toggle.
  final bool? toggled;

  /// Selection state (e.g. the pinned tile). Null: not selectable.
  final bool? selected;

  /// Shown on hover and long press; excluded from semantics so the name is
  /// not read twice.
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool pressScale;

  /// Scale while pressed: below 1 shrinks (default), above 1 is the 0.1.6
  /// bounce (`AppMotion.bounceScale`, `bounceScaleSmall`). In with
  /// `AppMotion.pressIn`, back with an easeOutBack overshoot.
  final double pressedScale;

  /// Duration of the press-in scale (0.1.6 `CustomBounceButton.duration`);
  /// the release always takes `AppMotion.pressRelease`.
  final Duration pressInDuration;

  static const Map<ShortcutActivator, Intent> _shortcuts = {
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.gameButtonA): ActivateIntent(),
  };

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  late final Map<Type, Action<Intent>> _actions = {
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: _activate,
    ),
  };

  Object? _activate(Intent intent) {
    widget.onPressed?.call();
    return null;
  }

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  void didUpdateWidget(AppPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _hovered = false;
      _pressed = false;
    }
  }

  Set<WidgetState> get _states => {
    if (!_enabled) WidgetState.disabled,
    if (_hovered) WidgetState.hovered,
    if (_focused) WidgetState.focused,
    if (_pressed) WidgetState.pressed,
    if (widget.selected ?? false) WidgetState.selected,
  };

  @override
  Widget build(BuildContext context) {
    Widget content = widget.builder(context, _states);
    if (widget.semanticLabel != null) {
      content = ExcludeSemantics(child: content);
    }

    if (widget.pressScale && !AppMotion.reduced(context)) {
      content = AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1,
        duration: _pressed ? widget.pressInDuration : AppMotion.pressRelease,
        curve: _pressed ? AppMotion.pressInCurve : AppMotion.pressReleaseCurve,
        child: content,
      );
    }

    content = GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: widget.onPressed,
      onLongPress: _enabled ? widget.onLongPress : null,
      child: content,
    );

    // Press feedback starts on pointer down, before the gesture arena
    // decides (0.1.6 bounce buttons used a Listener too), so it does not
    // wait for kPressTimeout next to a tooltip or inside a scroll view.
    content = Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _enabled ? (_) => _setPressed(true) : null,
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: content,
    );

    content = FocusableActionDetector(
      enabled: _enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      shortcuts: AppPressable._shortcuts,
      actions: _actions,
      mouseCursor: _enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      onShowHoverHighlight: (value) => setState(() => _hovered = value),
      child: content,
    );

    // Outermost, so the focusable/focused flags of the Focus widget inside
    // merge into this button node.
    content = Semantics(
      container: true,
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      toggled: widget.toggled,
      selected: widget.selected,
      onTap: widget.onPressed,
      onLongPress: _enabled ? widget.onLongPress : null,
      child: content,
    );

    final tooltip = widget.tooltip;
    if (tooltip != null && tooltip.isNotEmpty) {
      content = Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: content,
      );
    }
    return content;
  }
}
