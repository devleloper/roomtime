import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dialogs/glass_dialog.dart';
import '../../../invite/invite_panel.dart';
import '../bloc/room_bloc.dart';
import 'media_shortcuts.dart';
import 'participants_panel.dart';
import '../../../../l10n/l10n.dart';

/// In-call invite (flows.md §3) in the glass dialog; the host can change
/// the code here.
Future<void> showCallInviteSheet(BuildContext context) {
  final bloc = context.read<RoomBloc>();
  return showGlassDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: BlocBuilder<RoomBloc, RoomState>(
        buildWhen: (previous, current) => current is RoomInCall,
        builder: (context, state) {
          if (state is! RoomInCall) return const SizedBox.shrink();
          return GlassDialogContent(
            title: context.l10n.inviteTitle,
            body: [
              InvitePanel(
                code: state.room.code,
                inviteUrl: state.inviteUrl,
                roomName: state.room.name,
                passwordProtected: state.room.passwordRequired,
                onRotate: state.isHost
                    ? () => confirmRotateInvite(context)
                    : null,
              ),
            ],
            actions: [
              GlassDialogButton(
                label: context.l10n.inviteDone,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    ),
  );
}

/// Participants and the host's room settings in the glass dialog.
Future<void> showParticipantsSheet(BuildContext context) {
  final bloc = context.read<RoomBloc>();
  return showGlassDialog<void>(
    context: context,
    builder: (_) =>
        BlocProvider.value(value: bloc, child: const ParticipantsPanel()),
  );
}

/// Shortcut help (flows.md §11).
Future<void> showShortcutsHelp(BuildContext context) => showGlassDialog<void>(
  context: context,
  builder: (context) => GlassDialogContent(
    title: context.l10n.roomShortcutsTitle,
    body: [
      for (final (label, keys) in [
        (context.l10n.roomShortcutMic, shortcutLabel('D')),
        (context.l10n.roomShortcutCamera, shortcutLabel('E')),
        (context.l10n.roomShortcutPeople, shortcutLabel('P', alt: true)),
        (context.l10n.roomShortcutHelp, shortcutLabel('/')),
      ])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(child: GlassDialogText(label)),
              Text(keys, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
    ],
    actions: [
      GlassDialogButton(
        label: context.l10n.roomClose,
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  ),
);
