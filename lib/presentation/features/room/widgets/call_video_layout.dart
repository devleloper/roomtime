import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../domain/entities/call_snapshot.dart';
import '../../../theme/theme.dart';
import 'draggable_pip_view.dart';
import 'mission_control_grid.dart';
import 'participant_tile.dart';
import '../../../../l10n/l10n.dart';

/// Picks the call layout by participant count (flows.md §5): self alone,
/// 1:1 with a draggable PiP (tap swaps, pinch zooms the large tile), or the
/// animated grid.
class CallVideoLayout extends StatefulWidget {
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

  final CallSnapshot call;
  final bool isHost;

  /// Tap on the video area (toggles the controls).
  final VoidCallback onBackgroundTap;

  /// Host: long-press opens participant actions (secondary path).
  final ValueChanged<CallParticipant>? onParticipantLongPress;

  /// Shown centered while the user is alone (the invite card).
  final Widget? aloneOverlay;

  /// How long the card waits after the others left (see `_aloneGrace`).
  final Duration aloneCardDelay;
  final double pipBottomInset;

  @override
  State<CallVideoLayout> createState() => _CallVideoLayoutState();
}

class _CallVideoLayoutState extends State<CallVideoLayout> {
  /// Participant shown large in the 1:1 layout; null means the remote one.
  String? _largeId;

  /// Everyone else just left: the invite card waits [aloneCardDelay], so a
  /// removal or "end for everyone" (LiveKit drops the others before the
  /// room disconnect arrives) never flashes "You're the only one here".
  /// Joining an empty room shows the card at once.
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
        if (mounted) setState(() => _aloneGrace = null);
      });
    }
  }

  @override
  void dispose() {
    _aloneGrace?.cancel();
    super.dispose();
  }

  VoidCallback? _longPress(CallParticipant p) {
    final handler = widget.onParticipantLongPress;
    if (handler == null || p.isLocal) return null;
    return () => handler(p);
  }

  Widget _tile(
    CallParticipant p, {
    bool fullBleed = false,
    bool cover = true,
    bool showActiveSpeaker = true,
    VoidCallback? onTap,
    String? tapHint,
  }) => ParticipantTile(
    key: ValueKey(p.id),
    participant: p,
    isLocalHost: widget.isHost,
    frontCamera: widget.call.frontCamera,
    fullBleed: fullBleed,
    cover: cover,
    showActiveSpeaker: showActiveSpeaker,
    onTap: onTap,
    tapHint: tapHint,
    onLongPress: _longPress(p),
  );

  Widget _backgroundTapTarget() => Positioned.fill(
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onBackgroundTap,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final participants = widget.call.participants;
    if (participants.isEmpty) return const SizedBox.shrink();

    if (participants.length == 1) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _tile(participants.single, fullBleed: true),
          _backgroundTapTarget(),
          if (widget.aloneOverlay != null && _aloneGrace == null)
            SafeArea(
              child: Padding(
                // Keeps the card clear of the top bar and the controls.
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

    if (participants.length == 2) return _oneToOne(context, participants);

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
              // Remote video is letterboxed so nothing is cropped away.
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
