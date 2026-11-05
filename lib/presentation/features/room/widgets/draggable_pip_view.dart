import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

/// Picture-in-picture tile: drag anywhere, pinch to resize, snaps to the
/// nearest side on release; tap swaps it with the full-screen tile.
class DraggablePipView extends StatefulWidget {
  const DraggablePipView({
    super.key,
    required this.child,
    this.initialSize = AppSizes.pip,
    this.minScale = 0.8,
    this.maxScale = 2.5,
    this.bottomInset = 120,
    this.onTap,
  });

  final Widget child;
  final Size initialSize;
  final double minScale;
  final double maxScale;

  /// Space kept free at the bottom for the controls bar.
  final double bottomInset;
  final VoidCallback? onTap;

  @override
  State<DraggablePipView> createState() => _DraggablePipViewState();
}

class _DraggablePipViewState extends State<DraggablePipView>
    with SingleTickerProviderStateMixin {
  static const _margin = AppSpacing.lg;

  // Starts far away so the first clamp puts it in the bottom-end corner.
  Offset _position = const Offset(100000, 100000);
  double _scale = 1;
  double _baseScale = 1;

  late final AnimationController _snap = AnimationController(
    vsync: this,
    duration: AppMotion.pipSnap,
  )..addListener(_onSnapTick);
  Animation<Offset>? _snapAnimation;

  @override
  void dispose() {
    _snap.dispose();
    super.dispose();
  }

  void _onSnapTick() {
    final animation = _snapAnimation;
    if (animation != null) setState(() => _position = animation.value);
  }

  Size get _size => widget.initialSize * _scale;

  Rect _bounds(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final size = _size;
    final minX = _margin + padding.left;
    final minY = _margin + padding.top;
    final maxX = screen.width - size.width - _margin - padding.right;
    final maxY = screen.height - size.height - _margin - widget.bottomInset;
    return Rect.fromLTRB(
      minX,
      minY,
      maxX < minX ? minX : maxX,
      maxY < minY ? minY : maxY,
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _snap.stop();
    _baseScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_baseScale * details.scale).clamp(
        widget.minScale,
        widget.maxScale,
      );
      _position += details.focalPointDelta;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final bounds = _bounds(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final centerX = _position.dx + _size.width / 2;
    final target = Offset(
      centerX < screenWidth / 2 ? bounds.left : bounds.right,
      _position.dy.clamp(bounds.top, bounds.bottom),
    );
    final duration = AppMotion.resolve(context, AppMotion.pipSnap);
    if (duration == Duration.zero) {
      setState(() => _position = target);
      return;
    }
    _snap.duration = duration;
    _snapAnimation = Tween(
      begin: _position,
      end: target,
    ).animate(CurvedAnimation(parent: _snap, curve: AppMotion.standard));
    _snap.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // Re-clamped on every build so rotation keeps it on screen.
    final bounds = _bounds(context);
    _position = Offset(
      _position.dx.clamp(bounds.left, bounds.right),
      _position.dy.clamp(bounds.top, bounds.bottom),
    );
    final size = _size;
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      width: size.width,
      height: size.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        // Elevation and shadow colour from the theme tokens.
        child: Material(
          elevation: AppElevation.level3,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shadowColor: Theme.of(context).colorScheme.shadow,
          borderRadius: AppRadius.lgAll,
          clipBehavior: Clip.antiAlias,
          child: widget.child,
        ),
      ),
    );
  }
}
