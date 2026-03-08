import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassContainer extends StatelessWidget {
  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16.0,
    this.blur = 12.0,
    this.padding = EdgeInsets.zero,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The background color of the container. Best used with semitransparent opacity (0.1 - 0.5).
  final Color? backgroundColor;

  /// Optional border color. Defaults to white with 15% opacity if null. Set to Colors.transparent to remove.
  final Color? borderColor;

  /// The radius of the corners.
  final double borderRadius;

  /// The amount of blur to apply. Defaults to 12.0.
  final double blur;

  /// Padding applied directly to the child content before the glass shader.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // Determine renderer based on platform
    final bool useLiquid =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.iOS);
    final theme = Theme.of(context);

    final resolvedBgColor =
        backgroundColor ?? theme.colorScheme.surface.withValues(alpha: 0.4);
    final resolvedBorderColor =
        borderColor ?? Colors.white.withValues(alpha: 0.15);

    Widget innerContent = Padding(padding: padding, child: child);

    if (useLiquid) {
      // Apple specific FakeGlass rendering
      return FakeGlass(
        shape: LiquidRoundedRectangle(
          borderRadius: borderRadius,
          side: resolvedBorderColor == Colors.transparent
              ? BorderSide.none
              : BorderSide(color: resolvedBorderColor, width: 1),
        ),
        settings: LiquidGlassSettings(
          blur:
              blur *
              2, // LiquidGlass blur feels weaker, doubling to match BackdropFilter
          glassColor: resolvedBgColor,
        ),
        child: innerContent,
      );
    }

    // Cross-platform BackdropFilter fallback
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: resolvedBgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: resolvedBorderColor == Colors.transparent
                ? null
                : Border.all(color: resolvedBorderColor, width: 1),
          ),
          child: innerContent,
        ),
      ),
    );
  }
}
