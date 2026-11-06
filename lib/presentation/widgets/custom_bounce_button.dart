import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/app_pressable.dart';
import 'package:roomtime/presentation/widgets/focus_ring.dart';

class CustomBounceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double scaleFactor;
  final Duration duration;
  final double overlayOpacity;
  final double borderRadius;

  final String? semanticLabel;
  final String? tooltip;

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
      builder: (context, states) {
        final isPressed = states.contains(WidgetState.pressed);
        final isFocused = states.contains(WidgetState.focused);

        return MinTapTarget(
          child: FocusRing(
            visible: isFocused,
            borderRadius: radius,
            child: Stack(
              alignment: Alignment.center,
              children: [
                child,
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: isPressed ? overlayOpacity : 0,
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
        );
      },
    );
  }
}

class MinTapTarget extends StatelessWidget {
  final Widget child;

  const MinTapTarget({super.key, required this.child});

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
