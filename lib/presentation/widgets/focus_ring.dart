import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

class FocusRing extends StatelessWidget {
  final bool visible;
  final Widget child;

  final BorderRadius borderRadius;
  final Color? color;

  const FocusRing({
    super.key,
    required this.visible,
    required this.child,
    this.borderRadius = AppRadius.fullAll,
    this.color,
  });

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
