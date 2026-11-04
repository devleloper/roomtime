import 'package:flutter/material.dart';

import '../theme/app_color_schemes.dart';
import '../theme/app_tokens.dart';

/// Draws a keyboard focus ring outside [child] with a gap, without changing
/// the child's layout. Contrast of the ring (`AppSemanticColors.focusRing`)
/// against the surrounding surface is >= 3:1 (WCAG 2.4.7, 1.4.11).
class FocusRing extends StatelessWidget {
  const FocusRing({
    super.key,
    required this.visible,
    required this.child,
    this.borderRadius = AppRadius.fullAll,
    this.color,
  });

  final bool visible;
  final Widget child;

  /// Radius of [child]; the ring follows it, grown by the gap.
  final BorderRadius borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const inset = -(AppSizes.focusRingGap + AppSizes.focusRingWidth);
    const grow = Radius.circular(
      AppSizes.focusRingGap + AppSizes.focusRingWidth,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (visible)
          Positioned(
            left: inset,
            top: inset,
            right: inset,
            bottom: inset,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: borderRadius.topLeft + grow,
                    topRight: borderRadius.topRight + grow,
                    bottomLeft: borderRadius.bottomLeft + grow,
                    bottomRight: borderRadius.bottomRight + grow,
                  ),
                  border: Border.all(
                    color: color ?? AppSemanticColors.of(context).focusRing,
                    width: AppSizes.focusRingWidth,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
