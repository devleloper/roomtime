import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidBounceButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color bgColor;
  final double size;
  final double iconSize;

  const LiquidBounceButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.bgColor,
    this.size = 60,
    this.iconSize = 28,
  });

  @override
  State<LiquidBounceButton> createState() => _LiquidBounceButtonState();
}

class _LiquidBounceButtonState extends State<LiquidBounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 2.0,
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
      1.15, // Increased scale inflation (lift more)
      duration: const Duration(milliseconds: 150),
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
    // Determine renderer based on platform
    final bool useLiquid =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.iOS);

    Widget innerContent = SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Icon(
              widget.icon,
              key: ValueKey(widget.icon),
              color: Colors.white,
              size: widget.iconSize,
            ),
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _isPressed ? 0.2 : 0.0, // White glare strength
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final glassContent = ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: useLiquid
          // Apple specific FakeGlass rendering
          ? FakeGlass(
              shape: LiquidOval(
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              settings: LiquidGlassSettings(
                blur: 24.0,
                glassColor: widget.bgColor,
              ),
              child: innerContent,
            )
          // Cross-platform BackdropFilter fallback
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: innerContent,
              ),
            ),
    );

    // Apply the package's native stretch physics + our custom scale up
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: GestureDetector(
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: LiquidStretch(
          interactionScale: 1.05, // Slight package-level scale up
          stretch: 0.2, // rubber band effect on drag
          child: Transform.scale(
            scale: _controller.value, // our custom pop scale
            child: glassContent,
          ),
        ),
      ),
    );
  }
}
