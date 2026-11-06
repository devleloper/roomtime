import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/theme/app_color_schemes.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';
import 'package:roomtime/presentation/widgets/participant_video.dart';

String participantName(BuildContext context, CallParticipant participant) {
  if (participant.displayName.isEmpty) {
    return context.l10n.roomSomeone;
  }
  return participant.displayName;
}

class ParticipantTile extends StatelessWidget {
  final CallParticipant participant;
  final bool isLocalHost;
  final bool frontCamera;
  final bool fullBleed;
  final bool cover;
  final bool showActiveSpeaker;
  final String? tapHint;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ParticipantTile({
    super.key,
    required this.participant,
    this.isLocalHost = false,
    this.frontCamera = true,
    this.fullBleed = false,
    this.cover = true,
    this.showActiveSpeaker = true,
    this.tapHint,
    this.onTap,
    this.onLongPress,
  });

  String _semanticsLabel(BuildContext context) {
    final p = participant;
    final parts = <String>[
      p.isLocal
          ? context.l10n.roomNameYou(participantName(context, p))
          : participantName(context, p),
      if (p.isLocal && isLocalHost) context.l10n.roomHost,
      if (p.isSpeaking) context.l10n.roomSpeaking,
      if (!p.microphoneEnabled) context.l10n.roomMicOff,
      if (!p.cameraEnabled) context.l10n.roomCamOff,
      if (p.weakConnection) context.l10n.roomWeakConnection,
    ];
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final speaking = showActiveSpeaker && participant.isSpeaking;
    final radius = fullBleed ? BorderRadius.zero : AppRadius.lgAll;

    Widget video = ParticipantVideo(
      videoTrack: participant.cameraEnabled ? participant.videoTrack : null,
      name: participantName(context, participant),
      colorSeed: participant.identity,
      cover: cover,
    );
    if (participant.isLocal) {
      video = _CameraFlip(front: frontCamera, child: video);
    }

    return Semantics(
      container: true,
      label: _semanticsLabel(context),
      onTapHint: onTap == null ? null : tapHint,
      onTap: onTap,
      onLongPress: onLongPress,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: AppMotion.resolve(context, AppMotion.short),
          // Keep glow in decoration and border in foregroundDecoration so boxShadow doesn't tint the video.
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: speaking
                ? [
                    BoxShadow(
                      color: Colors.greenAccent.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: radius,
            border: speaking
                ? Border.all(color: Colors.greenAccent, width: 3)
                : null,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                video,
                PositionedDirectional(
                  start: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  end: AppSpacing.sm,
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: _NamePill(
                      participant: participant,
                      isLocalHost: isLocalHost,
                      speaking: participant.isSpeaking,
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
}

class _NamePill extends StatelessWidget {
  final CallParticipant participant;
  final bool isLocalHost;
  final bool speaking;

  const _NamePill({
    required this.participant,
    required this.isLocalHost,
    required this.speaking,
  });

  String _resolveDisplayName(BuildContext context) {
    final baseName = participantName(context, participant);
    if (!participant.isLocal) {
      return baseName;
    }
    if (isLocalHost) {
      return context.l10n.roomNameYouHost(baseName);
    }
    return context.l10n.roomNameYou(baseName);
  }

  @override
  Widget build(BuildContext context) {
    final semantic = AppSemanticColors.of(context);
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: semantic.onVideoScrim);
    final name = _resolveDisplayName(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: semantic.videoScrim,
        borderRadius: AppRadius.fullAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!participant.microphoneEnabled) ...[
              Icon(
                Icons.mic_off,
                size: AppSizes.iconSm * 0.8,
                color: semantic.onVideoScrim,
              ),
              const SizedBox(width: AppSpacing.xs),
            ] else if (speaking) ...[
              Icon(
                Icons.graphic_eq,
                size: AppSizes.iconSm * 0.8,
                color: semantic.onVideoScrim,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                name,
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (participant.weakConnection) ...[
              const SizedBox(width: AppSpacing.xs),
              Tooltip(
                message: context.l10n.roomWeakConnectionTitle,
                excludeFromSemantics: true,
                child: Icon(
                  Icons.signal_cellular_alt_1_bar,
                  size: AppSizes.iconSm * 0.8,
                  color: semantic.onVideoScrim,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CameraFlip extends StatefulWidget {
  final bool front;
  final Widget child;

  const _CameraFlip({required this.front, required this.child});

  @override
  State<_CameraFlip> createState() {
    return _CameraFlipState();
  }
}

class _CameraFlipState extends State<_CameraFlip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.long,
  );

  @override
  void didUpdateWidget(_CameraFlip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.front != oldWidget.front && !AppMotion.reduced(context)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        final direction = widget.front ? 1.0 : -1.0;
        final angle = (t <= 0.5 ? t : t - 1) * math.pi * direction;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
