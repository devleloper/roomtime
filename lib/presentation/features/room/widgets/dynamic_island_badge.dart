import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/device_utils.dart';
import '../../../widgets/liquid_glass_container.dart';

class DynamicIslandBadge extends StatefulWidget {
  final String roomName;
  final bool isVisible;

  const DynamicIslandBadge({
    super.key,
    required this.roomName,
    required this.isVisible,
  });

  @override
  State<DynamicIslandBadge> createState() => _DynamicIslandBadgeState();
}

class _DynamicIslandBadgeState extends State<DynamicIslandBadge> {
  bool _hasDynamicIsland = false;
  bool _isExpanded = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkDevice();
  }

  Future<void> _checkDevice() async {
    final hasIsland = await DeviceUtils.hasDynamicIsland();
    if (!mounted) return;

    setState(() {
      _hasDynamicIsland = hasIsland;
      _isInitialized = true;
    });

    if (hasIsland) {
      // Delay expansion slightly so the hardware-aligned black pill renders first,
      // creating an organic spring effect from the top.
      Timer(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            _isExpanded = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox.shrink();
    }

    final topPadding = MediaQuery.of(context).padding.top;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (!_hasDynamicIsland || isLandscape) {
      // Fallback for non-island or landscape devices using standard explicit animation
      return Positioned(
        top: topPadding + 16,
        left: 0,
        right: 0,
        child: AnimatedSlide(
          offset: widget.isVisible ? Offset.zero : const Offset(0, -1.5),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: widget.isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !widget.isVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LiquidGlassContainer(
                    blur: 12,
                    borderRadius: 100,
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    borderColor: Colors.white.withValues(alpha: 0.15),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: Text(
                      widget.roomName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Dynamic Island Extrusion Animation

    // Hardware constraints for the Dynamic Island
    const double islandWidth = 125.0;
    const double islandHeight = 37.0;
    const double islandTop = 11.0;

    // Target position for the expanded badge
    final double targetTop = topPadding + 16;

    // Morph between the hardware island pill and the LiquidGlass badge
    final bool showExpanded = _isExpanded && widget.isVisible;

    // Use a smooth deceleration curve without bounce
    const curve = Curves.easeOutQuint;
    const duration = Duration(milliseconds: 650);

    return AnimatedPositioned(
      top: showExpanded ? targetTop : islandTop,
      left: 0,
      right: 0,
      duration: duration,
      curve: curve,
      child: IgnorePointer(
        ignoring: !widget.isVisible,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Apply color tween to the container itself rather than the child
            TweenAnimationBuilder<Color?>(
              duration: duration,
              curve: curve,
              tween: ColorTween(
                begin: Colors.black,
                end: showExpanded
                    ? Colors.black.withValues(alpha: 0.5)
                    : Colors.black,
              ),
              builder: (context, color, child) {
                return LiquidGlassContainer(
                  blur: showExpanded ? 12 : 0,
                  borderRadius: 100,
                  backgroundColor: color,
                  borderColor: showExpanded
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.transparent,
                  padding: EdgeInsets.zero,
                  child: AnimatedSize(
                    duration: duration,
                    curve: curve,
                    alignment: Alignment.center,
                    child: Container(
                      width: showExpanded ? null : islandWidth,
                      height: showExpanded ? null : islandHeight,
                      padding: showExpanded
                          ? const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            )
                          : EdgeInsets.zero,
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                        opacity: showExpanded ? 1.0 : 0.0,
                        duration: duration,
                        curve: curve,
                        child: Text(
                          widget.roomName,
                          maxLines: 1,
                          overflow: showExpanded
                              ? TextOverflow.visible
                              : TextOverflow.clip,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
