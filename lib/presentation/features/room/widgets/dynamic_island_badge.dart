import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';

class DynamicIslandBadge extends StatefulWidget {
  final String roomName;
  final bool isVisible;
  final bool hasDynamicIsland;
  final double islandOffset;

  const DynamicIslandBadge({
    super.key,
    required this.roomName,
    required this.isVisible,
    this.hasDynamicIsland = false,
    this.islandOffset = 0,
  });

  @override
  State<DynamicIslandBadge> createState() {
    return _DynamicIslandBadgeState();
  }
}

class _DynamicIslandBadgeState extends State<DynamicIslandBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: 0,
  );
  bool _started = false;

  bool get _island {
    return widget.hasDynamicIsland;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _animateTo(widget.isVisible);
    }
  }

  @override
  void didUpdateWidget(DynamicIslandBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible ||
        oldWidget.hasDynamicIsland != widget.hasDynamicIsland) {
      _animateTo(widget.isVisible);
    }
  }

  Duration _resolveDuration(bool visible) {
    if (_island) {
      return AppMotion.islandMorph;
    }
    if (visible) {
      return AppMotion.pillIn;
    }
    return AppMotion.pillOut;
  }

  void _animateTo(bool visible) {
    final target = visible ? 1.0 : 0.0;
    if (AppMotion.reduced(context)) {
      _controller.value = target;
      return;
    }
    final duration = _resolveDuration(visible);
    _controller.animateTo(target, duration: duration, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final semantic = AppSemanticColors.of(context);
    final style = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: semantic.onVideoScrim);
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Text(
        widget.roomName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      child: content,
      builder: (context, child) {
        final v = _controller.value;
        if (v == 0) {
          return const SizedBox.shrink();
        }
        return _island ? _morph(context, v, child!) : _slide(v, child!);
      },
    );
  }

  Widget _pill({
    required Widget child,
    Color? tint,
    double blurSigma = AppGlass.blurSigma,
    double highlight = 1,
    Color? border,
    double minHeight = AppSizes.glassPillHeight,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: GlassSurface(
        variant: GlassVariant.overlay,
        borderRadius: AppRadius.fullAll,
        tint: tint,
        blurSigma: blurSigma,
        highlight: highlight,
        borderColor: border,
        child: child,
      ),
    );
  }

  Widget _slide(double v, Widget child) {
    final t = AppMotion.chromeCurve.transform(v);
    return FractionalTranslation(
      translation: Offset(0, -1.5 * (1 - t)),
      child: Opacity(
        opacity: t,
        child: _pill(child: child),
      ),
    );
  }

  Widget _morph(BuildContext context, double v, Widget child) {
    final t = AppMotion.islandMorphCurve.transform(v);
    final semantic = AppSemanticColors.of(context);
    final black = semantic.videoScrim.withValues(alpha: 1);
    final textT = const Interval(0.45, 1).transform(v);
    return Transform.translate(
      offset: Offset(0, lerpDouble(widget.islandOffset, 0, t)!),
      child: _pill(
        minHeight: 0,
        tint: black.withValues(
          alpha: lerpDouble(1, AppGlass.overlayMinAlpha, t),
        ),
        blurSigma: AppGlass.blurSigma * t,
        highlight: t,
        border: semantic.onVideoScrim.withValues(
          alpha: AppGlass.borderAlpha * t,
        ),
        child: _SizeLerp(
          from: AppSizes.dynamicIsland,
          t: t,
          child: Opacity(opacity: textT, child: child),
        ),
      ),
    );
  }
}

class _SizeLerp extends SingleChildRenderObjectWidget {
  final Size from;
  final double t;

  const _SizeLerp({required this.from, required this.t, super.child});

  @override
  _RenderSizeLerp createRenderObject(BuildContext context) {
    return _RenderSizeLerp(from, t);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSizeLerp renderObject) {
    renderObject
      ..from = from
      ..t = t;
  }
}

class _RenderSizeLerp extends RenderShiftedBox {
  Size _from;
  double _t;

  _RenderSizeLerp(this._from, this._t) : super(null);

  set from(Size value) {
    if (value != _from) {
      _from = value;
      markNeedsLayout();
    }
  }

  set t(double value) {
    if (value != _t) {
      _t = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final child = this.child!;
    child.layout(constraints.loosen(), parentUsesSize: true);
    size = constraints.constrain(Size.lerp(_from, child.size, _t)!);
    (child.parentData! as BoxParentData).offset = Offset(
      (size.width - child.size.width) / 2,
      (size.height - child.size.height) / 2,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_t >= 1) {
      super.paint(context, offset);
      return;
    }
    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
    );
  }
}
