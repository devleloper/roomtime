import 'package:flutter/material.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';

class EndedView extends StatelessWidget {
  final CallEndReason reason;
  final bool endedByYou;
  final VoidCallback onRejoin;
  final VoidCallback onHome;
  final VoidCallback onNewRoom;

  const EndedView({
    super.key,
    required this.reason,
    required this.endedByYou,
    required this.onRejoin,
    required this.onHome,
    required this.onNewRoom,
  });

  GlassDialogButton _buildButton(
    String label,
    VoidCallback onPressed, {
    bool primary = false,
  }) {
    return GlassDialogButton(
      label: label,
      onPressed: onPressed,
      style: primary ? GlassButtonStyle.primary : GlassButtonStyle.secondary,
      autofocus: primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final home = _buildButton(context.l10n.roomHome, onHome);
    final homePrimary = _buildButton(
      context.l10n.roomHome,
      onHome,
      primary: true,
    );
    final rejoin = _buildButton(
      context.l10n.roomRejoin,
      onRejoin,
      primary: true,
    );
    final newRoom = _buildButton(context.l10n.roomNewRoom, onNewRoom);

    final (icon, title, message, actions) = switch (reason) {
      CallEndReason.left => (
        Icons.call_end,
        context.l10n.roomEndedLeft,
        null,
        [home, rejoin],
      ),
      CallEndReason.endedByHost when endedByYou => (
        Icons.call_end,
        context.l10n.roomEndedByYou,
        null,
        [newRoom, homePrimary],
      ),
      CallEndReason.endedByHost => (
        Icons.call_end,
        context.l10n.roomEndedByHost,
        context.l10n.roomEndedByHostBody,
        [homePrimary],
      ),
      CallEndReason.removed => (
        Icons.person_remove,
        context.l10n.roomEndedRemoved,
        null,
        [homePrimary],
      ),
      CallEndReason.roomDeleted => (
        Icons.timer_off,
        context.l10n.roomEndedExpired,
        context.l10n.roomEndedExpiredBody,
        [newRoom, homePrimary],
      ),
      CallEndReason.joinedElsewhere => (
        Icons.devices,
        context.l10n.roomEndedElsewhere,
        context.l10n.roomEndedElsewhereBody,
        [_buildButton(context.l10n.roomUseHere, onRejoin), homePrimary],
      ),
      CallEndReason.connectionLost => (
        Icons.wifi_off,
        context.l10n.roomEndedConnectionLost,
        context.l10n.roomEndedConnectionLostBody,
        [home, rejoin],
      ),
    };
    return GlassStatusScreen(
      icon: icon,
      title: title,
      message: message,
      actions: actions,
    );
  }
}
