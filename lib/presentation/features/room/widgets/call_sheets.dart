import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/widgets/media_shortcuts.dart';
import 'package:roomtime/presentation/features/room/widgets/participants_panel.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';
import 'package:roomtime/presentation/widgets/invite_panel.dart';

Future<void> showCallInviteSheet(BuildContext context) {
  final bloc = context.read<RoomBloc>();
  return showGlassDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: bloc,
      child: BlocBuilder<RoomBloc, RoomState>(
        buildWhen: (previous, current) => current is RoomInCall,
        builder: (context, state) {
          if (state is! RoomInCall) {
            return const SizedBox.shrink();
          }
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

Future<void> showParticipantsSheet(BuildContext context) {
  final bloc = context.read<RoomBloc>();
  return showGlassDialog<void>(
    context: context,
    builder: (_) =>
        BlocProvider.value(value: bloc, child: const ParticipantsPanel()),
  );
}

Future<void> showShortcutsHelp(BuildContext context) {
  return showGlassDialog<void>(
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
}
