import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/app_pressable.dart';
import 'package:roomtime/presentation/widgets/custom_bounce_button.dart'
    show MinTapTarget;
import 'package:roomtime/presentation/widgets/focus_ring.dart';
import 'package:roomtime/presentation/widgets/glass_effect.dart';

class LiquidBounceButton extends StatelessWidget {
  static final Map<IconData, (String, bool?)> _fallbackNames = {
    Icons.mic: ('Microphone', true),
    Icons.mic_off: ('Microphone', false),
    Icons.videocam: ('Camera', true),
    Icons.videocam_off: ('Camera', false),
    Icons.cameraswitch: ('Switch camera', null),
    Icons.call_end: ('Leave call', null),
    Icons.dangerous: ('End call for everyone', null),
    Icons.refresh: ('Refresh', null),
  };

  final VoidCallback onPressed;
  final IconData icon;
  final Color bgColor;
  final double size;
  final double iconSize;

  final String? semanticLabel;
  final String? tooltip;
  final bool? toggled;
  final FocusNode? focusNode;
  final bool autofocus;

  const LiquidBounceButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.bgColor,
    this.size = AppSizes.glassControl,
    this.iconSize = AppSizes.iconLg,
    this.semanticLabel,
    this.tooltip,
    this.toggled,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = _fallbackNames[icon];
    final label = semanticLabel ?? fallback?.$1;
    final defaultToggled = semanticLabel == null ? fallback?.$2 : null;
    final reduced = AppMotion.reduced(context);

    return AppPressable(
      onPressed: onPressed,
      semanticLabel: label,
      toggled: toggled ?? defaultToggled,
      tooltip: tooltip ?? label,
      focusNode: focusNode,
      autofocus: autofocus,
      pressedScale: AppMotion.bounceScale,
      builder: (context, states) {
        Widget glyph = Icon(
          icon,
          key: ValueKey(icon),
          color: AppColors.textPrimary,
          size: iconSize,
        );
        if (!reduced) {
          glyph = AnimatedSwitcher(
            duration: AppMotion.medium,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: glyph,
          );
        }

        final isPressed = states.contains(WidgetState.pressed);
        final isFocused = states.contains(WidgetState.focused);

        Widget circle = GlassEffect(
          oval: true,
          blurSigma: AppGlass.blurSigma,
          tint: bgColor,
          child: SizedBox.square(
            dimension: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                glyph,
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: isPressed ? AppGlass.pressedGlareAlpha : 0,
                    duration: AppMotion.resolve(context, AppMotion.glare),
                    curve: AppMotion.glareCurve,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        if (!reduced) {
          circle = SizedBox.square(
            dimension: size,
            child: _LiquidStretch(child: circle),
          );
        }
        return MinTapTarget(
          child: FocusRing(visible: isFocused, child: circle),
        );
      },
    );
  }
}

class _LiquidStretch extends StatefulWidget {
  final Widget child;

  const _LiquidStretch({required this.child});

  @override
  State<_LiquidStretch> createState() => _LiquidStretchState();
}

class _LiquidStretchState extends State<_LiquidStretch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: AppMotion.stretchSettle,
  )..addListener(() => setState(() {}));
  Offset? _down;
  Offset _drag = Offset.zero;
  Offset _released = Offset.zero;

  bool get _active => _down != null;

  Offset get _offset {
    if (_active) {
      return _drag;
    }
    final t = AppMotion.stretchSettleCurve.transform(_settle.value);
    return Offset.lerp(_released, Offset.zero, t)!;
  }

  void _start(PointerDownEvent event) {
    _settle.stop();
    setState(() {
      _down = event.localPosition;
      _drag = Offset.zero;
    });
  }

  void _move(PointerMoveEvent event) {
    final down = _down;
    if (down != null) {
      setState(() => _drag = _resist(event.localPosition - down));
    }
  }

  void _end(PointerEvent event) {
    if (!_active) {
      return;
    }
    setState(() {
      _released = _drag;
      _down = null;
    });
    _settle.forward(from: 0);
  }

  static Offset _resist(Offset offset) {
    final magnitude = offset.distance;
    if (magnitude == 0) {
      return Offset.zero;
    }
    final resisted = magnitude / (1 + magnitude * AppMotion.stretchResistance);
    return offset * (resisted / magnitude);
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _start,
      onPointerMove: _move,
      onPointerUp: _end,
      onPointerCancel: _end,
      child: AnimatedScale(
        scale: _active ? AppMotion.stretchScale : 1,
        duration: AppMotion.stretchIn,
        curve: AppMotion.chromeCurve,
        child: LayoutBuilder(
          builder: (context, constraints) => Transform(
            transform: _stretch(_offset * AppMotion.stretchFactor, constraints),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  static Matrix4 _stretch(Offset pixels, BoxConstraints constraints) {
    if (pixels == Offset.zero || !constraints.hasBoundedWidth) {
      return Matrix4.identity();
    }
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final rx = w > 0 ? pixels.dx.abs() / w : 0.0;
    final ry = h > 0 && h.isFinite ? pixels.dy.abs() / h : 0.0;
    final sx = 1 + rx;
    final sy = 1 + ry;
    final volume = 1 + math.sqrt(rx * rx + ry * ry) * 0.5;
    final correction = math.sqrt(volume / (sx * sy));
    return Matrix4.diagonal3Values(sx * correction, sy * correction, 1)
      ..translateByDouble(pixels.dx, pixels.dy, 0, 1);
  }
}
