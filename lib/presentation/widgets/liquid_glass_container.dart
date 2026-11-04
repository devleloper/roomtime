import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'glass_effect.dart';

/// Frosted glass container of dev-0.1.6 (original API and look): the
/// backdrop is saturated and blurred (sigma = [blur] x 2, as 0.1.6 doubled
/// it for FakeGlass), [backgroundColor] is multiplied in and a specular rim
/// catches the light at the top and bottom edges.
///
/// Same rendering on iOS, Android, macOS and web ([GlassEffect], no
/// shaders). Purely visual: it adds no semantics.
class LiquidGlassContainer extends StatelessWidget {
  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppRadius.lg,
    this.blur = AppGlass.containerBlur,
    this.padding = EdgeInsets.zero,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The background color of the container. Best used with semitransparent
  /// opacity (0.1 - 0.5). Defaults to `colorScheme.surface` at 40 %.
  final Color? backgroundColor;

  /// Rim color. Defaults to white; set to [Colors.transparent] to remove.
  /// As on 0.1.6 iOS, the rim is the glass's specular light, so only the
  /// color's hue is used, not its opacity.
  final Color? borderColor;

  /// The radius of the corners.
  final double borderRadius;

  /// The amount of blur to apply. Defaults to 12.0.
  final double blur;

  /// Padding applied directly to the child content.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassEffect(
      borderRadius: BorderRadius.circular(borderRadius),
      blurSigma: blur * AppGlass.blurFactor,
      tint:
          backgroundColor ??
          scheme.surface.withValues(alpha: AppGlass.containerTintAlpha),
      rimColor: borderColor ?? scheme.onSurface,
      child: Padding(padding: padding, child: child),
    );
  }
}
