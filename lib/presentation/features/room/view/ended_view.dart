import 'package:flutter/material.dart';

import '../../../../domain/entities/call_snapshot.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../../l10n/l10n.dart';

/// After the call (flows.md §9), in the system theme. "Rejoin" goes back to
/// the lobby, which always makes a fresh join request.
class EndedView extends StatelessWidget {
  const EndedView({
    super.key,
    required this.reason,
    required this.endedByYou,
    required this.onRejoin,
    required this.onHome,
    required this.onNewRoom,
  });

  final CallEndReason reason;
  final bool endedByYou;
  final VoidCallback onRejoin;
  final VoidCallback onHome;
  final VoidCallback onNewRoom;

  @override
  Widget build(BuildContext context) {
    GlassDialogButton button(
      String label,
      VoidCallback onPressed, {
      bool primary = false,
    }) => GlassDialogButton(
      label: label,
      onPressed: onPressed,
      style: primary ? GlassButtonStyle.primary : GlassButtonStyle.secondary,
      autofocus: primary,
    );
    final home = button(context.l10n.roomHome, onHome);
    final homePrimary = button(context.l10n.roomHome, onHome, primary: true);
    final rejoin = button(context.l10n.roomRejoin, onRejoin, primary: true);
    final newRoom = button(context.l10n.roomNewRoom, onNewRoom);

    // Buttons read secondary first, primary last (0.1.6 Cancel / Create).
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
        [button(context.l10n.roomUseHere, onRejoin), homePrimary],
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
