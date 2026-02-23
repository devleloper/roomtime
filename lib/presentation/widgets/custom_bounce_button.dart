import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomBounceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double scaleFactor;
  final Duration duration;

  const CustomBounceButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<CustomBounceButton> createState() => _CustomBounceButtonState();
}

class _CustomBounceButtonState extends State<CustomBounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SpringSimulation _springSimulation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
    );
    _springSimulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 500, damping: 15),
      0.0,
      1.0,
      0.0,
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

  void _onTapDown(TapDownDetails details) {
    _controller.animateTo(
      widget.scaleFactor,
      duration: widget.duration,
      curve: Curves.easeOut,
    );
  }

  void _onTapUp(TapUpDetails details) {
    _controller.animateWith(_springSimulation);
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.animateWith(_springSimulation);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Transform.scale(scale: _controller.value, child: widget.child),
    );
  }
}
