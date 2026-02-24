import 'package:flutter/material.dart';

class CustomBounceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double scaleFactor;
  final Duration duration;
  final double overlayOpacity;
  final double borderRadius;

  const CustomBounceButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.scaleFactor = 1.08, // Increased inflation for more pop
    this.duration = const Duration(milliseconds: 150),
    this.overlayOpacity = 0.2, // White glare strength
    this.borderRadius = 100.0, // Default to fully rounded (pill/circle)
  });

  @override
  State<CustomBounceButton> createState() => _CustomBounceButtonState();
}

class _CustomBounceButtonState extends State<CustomBounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 2.0, // Allow scaling slightly beyond 1.0
      value: 1.0,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() => _isPressed = true);
    _controller.animateTo(
      widget.scaleFactor,
      duration: widget.duration,
      curve: Curves.easeOut,
    );
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() => _isPressed = false);
    _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    );
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() => _isPressed = false);
    _controller.animateTo(
      1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: Transform.scale(
          scale: _controller.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              widget.child,
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _isPressed ? widget.overlayOpacity : 0.0,
                  duration: widget.duration,
                  curve: Curves.easeInOut,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
