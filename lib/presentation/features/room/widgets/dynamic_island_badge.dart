import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../theme/app_color_schemes.dart';
import '../../../theme/app_tokens.dart';
import '../../../widgets/glass_surface.dart';

/// The room name badge of dev-0.1.6 at the top of the call, with its
/// original constructor: white 16 w600 text on glass, stadium shape,
/// minimum height 44.
///
/// - [isVisible] drives the animation; a hidden badge leaves the semantics
///   tree.
/// - Without [hasDynamicIsland] (landscape, web, desktop, other phones) it
///   slides down from above and fades in (400 ms in, 300 ms out,
///   easeOutCubic).
/// - With [hasDynamicIsland] it grows out of the hardware island: a solid
///   black 125 x 37 pill over the island morphs into glass (650 ms
///   easeOutQuint, no bounce) and morphs back when hidden. The caller
///   decides whether the device has an island (portrait only);
///   [islandOffset] is the vertical distance from the badge's resting top
///   to the island's top, usually
///   `AppSizes.dynamicIslandTop - (safeTop + AppSpacing.lg)` (negative).
/// - Reduced motion: shows and hides instantly, no morph.
/// - The name is one line and ellipsizes; it scales with the text size.
class DynamicIslandBadge extends StatefulWidget {
  const DynamicIslandBadge({
    super.key,
    required this.roomName,
    required this.isVisible,
    this.hasDynamicIsland = false,
    this.islandOffset = 0,
  });

  final String roomName;
  final bool isVisible;
  final bool hasDynamicIsland;
  final double islandOffset;

  @override
  State<DynamicIslandBadge> createState() => _DynamicIslandBadgeState();
}

class _DynamicIslandBadgeState extends State<DynamicIslandBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: 0,
  );
  bool _started = false;

  bool get _island => widget.hasDynamicIsland;

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

  void _animateTo(bool visible) {
    final target = visible ? 1.0 : 0.0;
    if (AppMotion.reduced(context)) {
      _controller.value = target;
      return;
    }
    final duration = _island
        ? AppMotion.islandMorph
        : visible
        ? AppMotion.pillIn
        : AppMotion.pillOut;
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
        // The island is 37 tall; the size lerp below grows it to the pill.
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

/// Sizes itself between [from] and the child's natural size by [t], with
/// the child centred and clipped (the island growing into the pill).
class _SizeLerp extends SingleChildRenderObjectWidget {
  const _SizeLerp({required this.from, required this.t, super.child});

  final Size from;
  final double t;

  @override
  _RenderSizeLerp createRenderObject(BuildContext context) =>
      _RenderSizeLerp(from, t);

  @override
  void updateRenderObject(BuildContext context, _RenderSizeLerp renderObject) {
    renderObject
      ..from = from
      ..t = t;
  }
}

class _RenderSizeLerp extends RenderShiftedBox {
  _RenderSizeLerp(this._from, this._t) : super(null);

  Size _from;
  set from(Size value) {
    if (value != _from) {
      _from = value;
      markNeedsLayout();
    }
  }

  double _t;
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
