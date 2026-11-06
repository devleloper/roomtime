import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

// Frosted glass rendered with standard Flutter primitives (no custom shaders) for cross-platform parity.
class GlassEffect extends StatelessWidget {
  final Widget child;

  final BorderRadius borderRadius;

  final bool oval;

  final double blurSigma;
  final Color tint;

  final Color rimColor;

  final double rimStrength;

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

  static List<double> _saturation(double s) {
    const r = 0.299, g = 0.587, b = 0.114;
    final i = 1 - s;
    return [
      r * i + s,
      g * i,
      b * i,
      0,
      0,
      r * i,
      g * i + s,
      b * i,
      0,
      0,
      r * i,
      g * i,
      b * i + s,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
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
    if (oval) {
      return ClipOval(child: content);
    }
    return ClipRRect(borderRadius: borderRadius, child: content);
  }
}

class _GlassPainter extends CustomPainter {
  final bool oval;
  final BorderRadius borderRadius;
  final Color tint;
  final Color rimColor;
  final double rimStrength;
  final bool blendTint;

  const _GlassPainter({
    required this.oval,
    required this.borderRadius,
    required this.tint,
    required this.rimColor,
    required this.rimStrength,
    required this.blendTint,
  });

  Path _shape(Rect rect) {
    if (oval) {
      return Path()..addOval(rect);
    }
    return Path()..addRRect(borderRadius.toRRect(rect));
  }

  BlendMode _resolveTintBlendMode() {
    if (!blendTint) {
      return BlendMode.srcOver;
    }
    if (tint.computeLuminance() < 0.5) {
      return BlendMode.multiply;
    }
    return BlendMode.screen;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final rect = Offset.zero & size;
    final path = _shape(rect);
    if (tint.a > 0) {
      final mode = _resolveTintBlendMode();
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

  void _paintRim(Canvas canvas, Path path, Rect rect) {
    final intensity = AppGlass.lightIntensity * rimStrength;
    final thicknessFactor = (AppGlass.thickness / 5).clamp(0.0, 1.0);
    final alpha = Curves.easeOut.transform(intensity) * thicknessFactor;
    final color = rimColor.withValues(alpha: alpha);
    final x = math.cos(AppGlass.lightAngle);
    final y = math.sin(AppGlass.lightAngle);

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
