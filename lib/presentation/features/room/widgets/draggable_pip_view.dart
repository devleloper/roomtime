import 'package:flutter/material.dart';
import '../../../widgets/custom_bounce_button.dart';

class DraggablePipView extends StatefulWidget {
  final Widget child;
  final double initialWidth;
  final double initialHeight;
  final double minScale;
  final double maxScale;
  final VoidCallback? onTap;

  const DraggablePipView({
    super.key,
    required this.child,
    this.initialWidth = 120,
    this.initialHeight = 160,
    this.minScale = 0.8,
    this.maxScale = 2.5,
    this.onTap,
  });

  @override
  State<DraggablePipView> createState() => _DraggablePipViewState();
}

class _DraggablePipViewState extends State<DraggablePipView>
    with SingleTickerProviderStateMixin {
  late Offset _position;
  late double _scale;
  double _baseScale = 1.0;

  late AnimationController _animationController;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();
    _scale = 1.0;
    // Start at top right corner with some padding
    _position = const Offset(1000, 100); // Will be corrected on first build

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.addListener(() {
      if (_animation != null) {
        setState(() {
          _position = _animation!.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _animationController.stop();
    _baseScale = _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Handle scaling
      _scale = (_baseScale * details.scale).clamp(
        widget.minScale,
        widget.maxScale,
      );

      // Handle panning (translation)
      _position += details.focalPointDelta;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _snapToEdge();
  }

  void _snapToEdge() {
    final screenSize = MediaQuery.of(context).size;

    final currentWidth = widget.initialWidth * _scale;
    final currentHeight = widget.initialHeight * _scale;

    // Calculate boundaries with padding
    const padding = 16.0;
    final minX = padding;
    final maxX = screenSize.width - currentWidth - padding;
    final minY = padding + MediaQuery.of(context).padding.top;
    final maxY =
        screenSize.height -
        currentHeight -
        padding -
        100; // 100 for media controls

    double targetX = _position.dx;
    double targetY = _position.dy.clamp(minY, maxY);

    // Snap to left or right edge
    if (_position.dx + (currentWidth / 2) < screenSize.width / 2) {
      targetX = minX;
    } else {
      targetX = maxX;
    }

    _animation = Tween<Offset>(begin: _position, end: Offset(targetX, targetY))
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Correct initial position on first build
    final size = MediaQuery.of(context).size;
    final currentWidth = widget.initialWidth * _scale;
    final currentHeight = widget.initialHeight * _scale;
    if (_position.dx > size.width) {
      _position = Offset(
        size.width - currentWidth - 16,
        size.height - currentHeight - 116,
      );
    }

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        child: CustomBounceButton(
          onPressed: widget.onTap ?? () {},
          borderRadius: 16,
          overlayOpacity: 0.1,
          scaleFactor: 1.05, // Slight pop instead of shrink
          child: Container(
            width: widget.initialWidth * _scale,
            height: widget.initialHeight * _scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              child: IgnorePointer(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
