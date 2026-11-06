import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/widgets/draggable_pip_view.dart';
import 'package:roomtime/presentation/features/room/widgets/mission_control_grid.dart';
import 'package:roomtime/presentation/features/room/widgets/participant_tile.dart';
import 'package:roomtime/presentation/theme/app_tokens.dart';

class CallVideoLayout extends StatefulWidget {
  final CallSnapshot call;
  final bool isHost;

  final VoidCallback onBackgroundTap;

  final ValueChanged<CallParticipant>? onParticipantLongPress;

  final Widget? aloneOverlay;

  final Duration aloneCardDelay;
  final double pipBottomInset;

  const CallVideoLayout({
    super.key,
    required this.call,
    required this.isHost,
    required this.onBackgroundTap,
    this.onParticipantLongPress,
    this.aloneOverlay,
    this.aloneCardDelay = const Duration(seconds: 3),
    this.pipBottomInset = 120,
  });

  @override
  State<CallVideoLayout> createState() {
    return _CallVideoLayoutState();
  }
}

class _CallVideoLayoutState extends State<CallVideoLayout> {
  String? _largeId;

  // Delay the "only one here" card briefly so it doesn't flash when ending a call.
  Timer? _aloneGrace;

  @override
  void didUpdateWidget(CallVideoLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasAlone = oldWidget.call.participants.length <= 1;
    final alone = widget.call.participants.length == 1;
    if (!alone) {
      _aloneGrace?.cancel();
      _aloneGrace = null;
    } else if (!wasAlone) {
      _aloneGrace?.cancel();
      _aloneGrace = Timer(widget.aloneCardDelay, () {
        if (mounted) {
          setState(() => _aloneGrace = null);
        }
      });
    }
  }

  @override
  void dispose() {
    _aloneGrace?.cancel();
    super.dispose();
  }

  VoidCallback? _longPress(CallParticipant participant) {
    final handler = widget.onParticipantLongPress;
    if (handler == null || participant.isLocal) {
      return null;
    }
    return () => handler(participant);
  }

  Widget _tile(
    CallParticipant participant, {
    bool fullBleed = false,
    bool cover = true,
    bool showActiveSpeaker = true,
    VoidCallback? onTap,
    String? tapHint,
  }) {
    return ParticipantTile(
      key: ValueKey(participant.id),
      participant: participant,
      isLocalHost: widget.isHost,
      frontCamera: widget.call.frontCamera,
      fullBleed: fullBleed,
      cover: cover,
      showActiveSpeaker: showActiveSpeaker,
      onTap: onTap,
      tapHint: tapHint,
      onLongPress: _longPress(participant),
    );
  }

  Widget _backgroundTapTarget() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onBackgroundTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final participants = widget.call.participants;
    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }

    if (participants.length == 1) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _tile(participants.single, fullBleed: true),
          _backgroundTapTarget(),
          if (widget.aloneOverlay != null && _aloneGrace == null)
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: widget.pipBottomInset),
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: widget.aloneOverlay,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    if (participants.length == 2) {
      return _oneToOne(context, participants);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _backgroundTapTarget(),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: widget.pipBottomInset),
            child: MissionControlGrid(
              participants: participants,
              tileBuilder: (context, p) =>
                  _tile(p, onTap: widget.onBackgroundTap),
            ),
          ),
        ),
      ],
    );
  }

  Widget _oneToOne(BuildContext context, List<CallParticipant> participants) {
    final local = participants.firstWhere(
      (p) => p.isLocal,
      orElse: () => participants.last,
    );
    final remote = participants.firstWhere(
      (p) => !p.isLocal,
      orElse: () => participants.first,
    );
    final localLarge = _largeId == local.id;
    final large = localLarge ? local : remote;
    final small = localLarge ? remote : local;
    final duration = AppMotion.resolve(context, AppMotion.medium);

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: duration,
          child: InteractiveViewer(
            key: ValueKey(large.id),
            clipBehavior: Clip.none,
            panEnabled: false,
            minScale: 1,
            maxScale: 4,
            child: _tile(
              large,
              fullBleed: true,
              cover: large.isLocal,
              showActiveSpeaker: false,
              onTap: widget.onBackgroundTap,
            ),
          ),
        ),
        DraggablePipView(
          bottomInset: widget.pipBottomInset,
          child: AnimatedSwitcher(
            duration: duration,
            child: _tile(
              small,
              showActiveSpeaker: false,
              tapHint: context.l10n.roomSwap,
              onTap: () => setState(() => _largeId = small.id),
            ),
          ),
        ),
      ],
    );
  }
}
