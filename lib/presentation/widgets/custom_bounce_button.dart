import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_tokens.dart';
import 'app_pressable.dart';
import 'focus_ring.dart';

/// Tap feedback of dev-0.1.6 (original API and look): on touch [child]
/// grows to [scaleFactor] over [duration] (easeOut) under a white glare of
/// [overlayOpacity] clipped to [borderRadius], and springs back in 300 ms
/// with easeOutBack when released.
///
/// Accessibility, with no change to the look:
/// - one button node named by the text inside [child], or by
///   [semanticLabel] when the child has no text (icon only); [toggled] for
///   on/off controls;
/// - focusable; Enter, Space, Select and gamepad A activate it; a focus
///   ring appears only while navigating with a keyboard;
/// - the hit area is at least 48 x 48 dp (a smaller child is centred in it);
/// - [tooltip] for pointer users (not read as a second name);
/// - reduced motion: no scale, the glare appears without fading.
class CustomBounceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double scaleFactor;
  final Duration duration;
  final double overlayOpacity;
  final double borderRadius;

  /// Accessible name when [child] has no text; replaces the child's text.
  final String? semanticLabel;
  final String? tooltip;

  /// On/off state for toggle controls; null when not a toggle.
  final bool? toggled;
  final FocusNode? focusNode;
  final bool autofocus;

  const CustomBounceButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.scaleFactor = AppMotion.bounceScaleSmall,
    this.duration = AppMotion.pressIn,
    this.overlayOpacity = AppGlass.pressedGlareAlpha,
    this.borderRadius = 100.0,
    this.semanticLabel,
    this.tooltip,
    this.toggled,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return AppPressable(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      toggled: toggled,
      focusNode: focusNode,
      autofocus: autofocus,
      pressedScale: scaleFactor,
      pressInDuration: duration,
      builder: (context, states) => MinTapTarget(
        child: FocusRing(
          visible: states.contains(WidgetState.focused),
          borderRadius: radius,
          child: Stack(
            alignment: Alignment.center,
            children: [
              child,
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: states.contains(WidgetState.pressed)
                        ? overlayOpacity
                        : 0,
                    duration: AppMotion.resolve(context, duration),
                    curve: AppMotion.glareCurve,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        borderRadius: radius,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Centres [child] in an area of at least [AppSizes.minTarget] square
/// without changing the child's size: the visual stays as designed, the
/// touch target meets WCAG 2.5.8 / Material 48 dp.
class MinTapTarget extends StatelessWidget {
  const MinTapTarget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppSizes.minTarget,
        minHeight: AppSizes.minTarget,
      ),
      child: Align(widthFactor: 1, heightFactor: 1, child: child),
    );
  }
}
