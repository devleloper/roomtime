import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

typedef AppPressableBuilder =
    Widget Function(BuildContext context, Set<WidgetState> states);

class AppPressable extends StatefulWidget {
  static const Map<ShortcutActivator, Intent> _shortcuts = {
    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.numpadEnter): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
    SingleActivator(LogicalKeyboardKey.gameButtonA): ActivateIntent(),
  };

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final AppPressableBuilder builder;

  final String? semanticLabel;

  final bool? toggled;

  final bool? selected;

  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool pressScale;

  final double pressedScale;

  final Duration pressInDuration;

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

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  late final Map<Type, Action<Intent>> _actions = {
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate),
    ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
      onInvoke: _activate,
    ),
  };

  bool get _enabled => widget.onPressed != null;

  Set<WidgetState> get _states {
    return {
      if (!_enabled) WidgetState.disabled,
      if (_hovered) WidgetState.hovered,
      if (_focused) WidgetState.focused,
      if (_pressed) WidgetState.pressed,
      if (widget.selected ?? false) WidgetState.selected,
    };
  }

  Object? _activate(Intent intent) {
    widget.onPressed?.call();
    return null;
  }

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() {
        _pressed = value;
      });
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
