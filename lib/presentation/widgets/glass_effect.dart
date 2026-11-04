import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// The dev-0.1.6 glass material, drawn the way `liquid_glass_renderer`
/// 0.2.0-dev.4 `FakeGlass` drew it on iOS and macOS, but from Flutter
/// primitives only (`BackdropFilter`, clip, canvas): no shaders, no package,
/// identical on iOS, Android, macOS and web (CanvasKit and skwasm).
///
/// Layers, bottom to top, clipped to the shape:
/// 1. backdrop: saturation [AppGlass.saturation], then blur [blurSigma]
///    (mirror edges);
/// 2. [tint], multiplied into dark backdrops (screen for light tints), so a
///    dark tint darkens video instead of greying it;
/// 3. a specular rim: a 1.5 dp hard-light stroke plus a soft 2 dp overlay
///    stroke in [rimColor], lit from [AppGlass.lightAngle] (top and bottom
///    edges bright, sides fading out). This is the faint rim seen on
///    0.1.6 pills and circles;
/// 4. [child].
///
/// Model after `FakeGlass` (liquid_glass_renderer 0.2.0-dev.4, MIT,
/// Copyright 2025 Tim Lehmann for whynotmake.it); an independent
/// implementation, no code from the package is used.
///
/// Purely visual: no semantics, no hit testing changes.
class GlassEffect extends StatelessWidget {
  const GlassEffect({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.oval = false,
    this.blurSigma = AppGlass.blurSigma,
    this.tint = Colors.transparent,
    this.rimColor = Colors.white,
    this.rimStrength = 1,
  });

  final Widget child;

  /// Corner radii of the rounded-rectangle shape; ignored when [oval].
  final BorderRadius borderRadius;

  /// Circle/ellipse shape (0.1.6 `LiquidOval`).
  final bool oval;

  /// Backdrop blur; 0 draws no backdrop filter at all (high contrast, or
  /// the start of a morph), and the tint is painted normally.
  final double blurSigma;
  final Color tint;

  /// Rim color; its alpha is ignored (the light model sets the strength).
  /// [Colors.transparent] (alpha 0) draws no rim.
  final Color rimColor;

  /// 0..1 scale of the rim light (0.1.6 `visibility`, used by morphs).
  final double rimStrength;

  /// Saturation matrix (Rec. 601 luma, as FakeGlass).
  static List<double> _saturation(double s) {
    const r = 0.299, g = 0.587, b = 0.114;
    final i = 1 - s;
    return [
      r * i + s, g * i, b * i, 0, 0, //
      r * i, g * i + s, b * i, 0, 0, //
      r * i, g * i, b * i + s, 0, 0, //
      0, 0, 0, 1, 0, //
    ];
  }

  @override
  Widget build(BuildContext context) {
    final blur = blurSigma > 0;
    Widget content = CustomPaint(
      painter: _GlassPainter(
        oval: oval,
        borderRadius: borderRadius,
        tint: tint,
        rimColor: rimColor,
        rimStrength: rimStrength.clamp(0.0, 1.0),
        // Blend modes need the filtered backdrop in the same layer.
        blendTint: blur,
      ),
      child: child,
    );
    if (blur) {
      content = BackdropFilter(
        filter: ui.ImageFilter.compose(
          outer: ui.ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
            tileMode: TileMode.mirror,
          ),
          inner: ui.ColorFilter.matrix(_saturation(AppGlass.saturation)),
        ),
        child: content,
      );
    }
    return oval
        ? ClipOval(child: content)
        : ClipRRect(borderRadius: borderRadius, child: content);
  }
}

class _GlassPainter extends CustomPainter {
  const _GlassPainter({
    required this.oval,
    required this.borderRadius,
    required this.tint,
    required this.rimColor,
    required this.rimStrength,
    required this.blendTint,
  });

  final bool oval;
  final BorderRadius borderRadius;
  final Color tint;
  final Color rimColor;
  final double rimStrength;
  final bool blendTint;

  Path _shape(Rect rect) => oval
      ? (Path()..addOval(rect))
      : (Path()..addRRect(borderRadius.toRRect(rect)));

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final rect = Offset.zero & size;
    final path = _shape(rect);
    if (tint.a > 0) {
      final BlendMode mode = !blendTint
          ? BlendMode.srcOver
          : tint.computeLuminance() < 0.5
          ? BlendMode.multiply
          : BlendMode.screen;
      canvas.drawPath(
        path,
        Paint()
          ..color = tint
          ..blendMode = mode,
      );
    }
    if (rimColor.a > 0 && rimStrength > 0) {
      _paintRim(canvas, path, rect);
    }
  }

  /// Specular rim: a linear gradient along the light direction, bright at
  /// both ends and clear in the middle band, stroked along the outline.
  void _paintRim(Canvas canvas, Path path, Rect rect) {
    final intensity = AppGlass.lightIntensity * rimStrength;
    final thicknessFactor = (AppGlass.thickness / 5).clamp(0.0, 1.0);
    final alpha = Curves.easeOut.transform(intensity) * thicknessFactor;
    final color = rimColor.withValues(alpha: alpha);
    final x = math.cos(AppGlass.lightAngle);
    final y = math.sin(AppGlass.lightAngle);

    // Light coverage and how the band adapts to non-square shapes.
    final coverage = ui.lerpDouble(0.3, 0.5, intensity)!;
    final aspect = rect.width / rect.height;
    final alongShortSide = (aspect < 1 ? y : x).abs();
    final squash = ((1 - 1 / aspect) * (1 - alongShortSide)).clamp(0.0, 1.0);
    final inset = ui.lerpDouble(0, 0.5, squash)!;
    final band = ui.lerpDouble(coverage, 0.5, squash)!;

    final square = Rect.fromCircle(
      center: rect.center,
      radius: rect.size.longestSide / 2,
    );
    final clear = color.withValues(alpha: 0);
    final shader = LinearGradient(
      colors: [color, clear, clear, color],
      stops: [inset, band, 1 - band, 1 - inset],
      begin: Alignment(x, y),
      end: Alignment(-x, -y),
    ).createShader(square);

    canvas
      ..drawPath(
        path,
        Paint()
          ..shader = shader
          ..color = color.withValues(alpha: alpha * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ui.lerpDouble(1, 2, intensity)!
          ..blendMode = BlendMode.hardLight,
      )
      ..drawPath(
        path,
        Paint()
          ..shader = shader
          ..color = color.withValues(alpha: alpha * 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppGlass.thickness / 10
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            AppGlass.thickness / 40,
          )
          ..blendMode = BlendMode.overlay,
      );
  }

  @override
  bool shouldRepaint(_GlassPainter old) =>
      old.oval != oval ||
      old.borderRadius != borderRadius ||
      old.tint != tint ||
      old.rimColor != rimColor ||
      old.rimStrength != rimStrength ||
      old.blendTint != blendTint;
}
