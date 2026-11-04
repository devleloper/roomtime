import 'package:flutter/material.dart';

import '../theme/app_color_schemes.dart';
import '../theme/app_tokens.dart';
import 'glass_effect.dart';

/// Where a [GlassSurface] sits; decides its minimum opacity.
enum GlassVariant {
  /// Over static app backgrounds (home, lobby cards, dialogs).
  panel,

  /// Over live video or the camera (call controls, room pill, captions): a
  /// black tint of at least 60 % so white text stays >= 5.74:1 on any
  /// frame.
  overlay,
}

/// Frosted glass panel with a readability floor (the room name badge),
/// drawn with the dev-0.1.6 material ([GlassEffect]: saturated blur,
/// multiplied tint, specular rim), so it matches `LiquidGlassContainer`.
///
/// On top of the 0.1.6 look it keeps text readable: a [tint] lighter than
/// the variant minimum is raised to it, and with "Increase contrast" / high
/// contrast, or when [blur] is false, it drops the blur and uses a
/// near-opaque tint.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.variant = GlassVariant.panel,
    this.borderRadius = AppRadius.xlAll,
    this.padding = EdgeInsets.zero,
    this.tint,
    this.borderColor,
    this.blurSigma = AppGlass.blurSigma,
    this.blur,
    this.highlight = 1,
  });

  final Widget child;
  final GlassVariant variant;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  /// Fill color; defaults to `surfaceContainer` (panel) or the video scrim
  /// (overlay). Its alpha is raised to the variant minimum.
  final Color? tint;

  /// Rim color (white by default; only its hue is used, see
  /// [GlassEffect.rimColor]). Pass [Colors.transparent] for none.
  final Color? borderColor;
  final double blurSigma;

  /// Force blur on or off; null follows accessibility settings (see
  /// [blurAvailable]).
  final bool? blur;

  /// Strength of the specular rim, 0..1 (0 = none). Animations (the room
  /// pill morph) fade it in.
  final double highlight;

  /// Whether a live backdrop blur should be drawn in [context]: everywhere,
  /// web included, unless the user asks for high contrast.
  static bool blurAvailable(BuildContext context) =>
      !MediaQuery.highContrastOf(context);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = AppSemanticColors.of(context);
    final useBlur = (blur ?? blurAvailable(context)) && blurSigma > 0;

    final baseTint =
        tint ??
        switch (variant) {
          GlassVariant.panel => scheme.surfaceContainer,
          GlassVariant.overlay => semantic.videoScrim,
        };
    final minAlpha = switch ((variant, useBlur)) {
      (GlassVariant.panel, true) => AppGlass.panelMinAlpha,
      (GlassVariant.panel, false) => AppGlass.fallbackMinAlpha,
      (GlassVariant.overlay, true) => AppGlass.overlayMinAlpha,
      (GlassVariant.overlay, false) => AppGlass.overlayFallbackMinAlpha,
    };
    final fill = baseTint.a >= minAlpha
        ? baseTint
        : baseTint.withValues(alpha: minAlpha);
    final rim = switch (variant) {
      GlassVariant.panel => scheme.onSurface,
      GlassVariant.overlay => semantic.onVideoScrim,
    };
    return GlassEffect(
      borderRadius: borderRadius,
      blurSigma: useBlur ? blurSigma : 0,
      tint: fill,
      rimColor: borderColor ?? rim,
      rimStrength: highlight,
      child: Padding(padding: padding, child: child),
    );
  }
}
