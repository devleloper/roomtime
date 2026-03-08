import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../../../presentation/widgets/liquid_glass_container.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  final Widget child;
  final bool isActive;

  const ParticipantTile({
    super.key,
    required this.participant,
    required this.child,
    this.isActive = false,
  });

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Scale & Blur Reveal
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _entranceController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isActive
                    ? Colors.greenAccent
                    : Colors.transparent,
                width: 3.0,
              ),
              boxShadow: [
                if (widget.isActive)
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  widget.child,
                  if (_blurAnimation.value > 0.1)
                    LiquidGlassContainer(
                      blur: _blurAnimation.value,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      borderRadius: 12,
                      child: Container(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
