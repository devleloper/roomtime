import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import 'app_pressable.dart';
import 'custom_bounce_button.dart' show MinTapTarget;
import 'focus_ring.dart';
import 'glass_effect.dart';

/// Round glass icon button of dev-0.1.6 (original API and look): a [size]
/// glass circle tinted [bgColor] with a specular rim and a white [icon]. On
/// touch it grows to 1.15 (150 ms easeOut) with a white glare and a liquid
/// stretch toward the finger (x1.05, rubber band), and springs back with
/// easeOutBack; an icon change crossfades in 300 ms.
///
/// Sizes in 0.1.6: 60 (call controls, icon 28), 48 (phone refresh, 24),
/// 28 (sidebar refresh, 14).
///
/// Accessibility, with no change to the look:
/// - a button named [semanticLabel]; without it the name comes from the
///   0.1.6 icons (mic, camera, switch, hang-up, end for all, refresh), in
///   English: pass a localized label. [toggled] exposes on/off (keep the
///   label stable, "Microphone", and let the state carry on/off);
/// - focusable; Enter, Space, Select and gamepad A activate it; keyboard
///   focus ring around the circle;
/// - hit area at least 48 x 48 dp, so a 28 dp circle is padded;
/// - [tooltip] defaults to the name, for pointer users;
/// - reduced motion: no bounce, stretch or crossfade.
class LiquidBounceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color bgColor;
  final double size;
  final double iconSize;

  /// Accessible name; see the class docs for the fallback.
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

  /// Names (and toggle state) of the icons the 0.1.6 screens used.
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

  @override
  Widget build(BuildContext context) {
    final fallback = _fallbackNames[icon];
    final label = semanticLabel ?? fallback?.$1;
    final reduced = AppMotion.reduced(context);

    return AppPressable(
      onPressed: onPressed,
      semanticLabel: label,
      toggled: toggled ?? (semanticLabel == null ? fallback?.$2 : null),
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
                    opacity: states.contains(WidgetState.pressed)
                        ? AppGlass.pressedGlareAlpha
                        : 0,
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
          child: FocusRing(
            visible: states.contains(WidgetState.focused),
            child: circle,
          ),
        );
      },
    );
  }
}

/// The 0.1.6 `LiquidStretch` (interactionScale 1.05, stretch 0.2): while a
/// pointer is down the child grows slightly and stretches toward the drag
/// (with resistance, volume roughly preserved), then springs back.
/// Visual only; it does not take part in the gesture arena.
class _LiquidStretch extends StatefulWidget {
  const _LiquidStretch({required this.child});

  final Widget child;

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

  /// Scale toward the stretch, keeping the area close to `1 + 0.5 x` the
  /// relative stretch, then shift by it (as `RawLiquidStretch` of 0.1.6).
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
