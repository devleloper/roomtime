import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_effect.dart';

const double callHudTintAlpha = 0.7;

enum GlassVariant { panel, overlay }

class GlassSurface extends StatelessWidget {
  final Widget child;
  final GlassVariant variant;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? tint;
  final Color? borderColor;
  final double blurSigma;
  final bool? blur;
  final double highlight;

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

  static bool blurAvailable(BuildContext context) {
    return !MediaQuery.highContrastOf(context);
  }

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

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppRadius.lg,
    this.blur = AppGlass.containerBlur,
    this.padding = EdgeInsets.zero,
  });

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

class GlassPanel extends StatelessWidget {
  static const double overVideoTintAlpha = 0.75;

  final Widget child;
  final double tintAlpha;

  const GlassPanel({
    super.key,
    required this.child,
    this.tintAlpha = AppGlass.dialogTintAlpha,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      blur: 30,
      backgroundColor: AppColors.surface.withValues(alpha: tintAlpha),
      borderColor: Colors.white.withValues(alpha: 0.2),
      borderRadius: 24,
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}

class GlassHudPill extends StatelessWidget {
  final IconData icon;
  final String message;

  const GlassHudPill({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: LiquidGlassContainer(
        blur: 12,
        borderRadius: 100,
        backgroundColor: Colors.black.withValues(alpha: callHudTintAlpha),
        borderColor: Colors.white.withValues(alpha: 0.1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoVeil extends StatelessWidget {
  static const double tintAlpha = 0.6;

  final Widget child;

  const VideoVeil({super.key, this.child = const SizedBox.expand()});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      blur: AppGlass.veilBlurSigma / AppGlass.blurFactor,
      backgroundColor: Colors.black.withValues(alpha: tintAlpha),
      borderColor: Colors.transparent,
      borderRadius: 0,
      child: child,
    );
  }
}
