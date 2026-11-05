import 'package:flutter/material.dart';

import '../../../../domain/entities/call_snapshot.dart';
import '../../../../domain/entities/room.dart';
import '../../../dialogs/glass_dialog.dart';
import '../../../theme/theme.dart';
import 'participant_tile.dart';
import '../../../../l10n/l10n.dart';

enum LeaveChoice { leave, end }

enum ParticipantAction { mute, remove }

/// Host's Leave (flows.md §7) in the 0.1.6 glass dialog: Leave or End for
/// everyone, and for the latter a destructive confirmation with focus on
/// Cancel. Resolves to the confirmed choice, or null when dismissed.
Future<LeaveChoice?> showHostLeaveFlow(BuildContext context) async {
  final choice = await showGlassChoices<LeaveChoice>(
    context: context,
    title: context.l10n.roomLeaveSheetTitle,
    cancelLabel: context.l10n.roomCancel,
    choices: [
      (
        label: context.l10n.roomLeaveLeave,
        description: context.l10n.roomLeaveLeaveSub,
        icon: Icons.logout,
        value: LeaveChoice.leave,
        destructive: false,
      ),
      (
        label: context.l10n.roomLeaveEnd,
        description: context.l10n.roomLeaveEndSub,
        icon: Icons.call_end,
        value: LeaveChoice.end,
        destructive: true,
      ),
    ],
  );
  if (choice != LeaveChoice.end || !context.mounted) return choice;
  final confirmed = await showGlassConfirm(
    context: context,
    title: context.l10n.roomLeaveConfirmTitle,
    message: context.l10n.roomLeaveConfirmBody,
    confirmLabel: context.l10n.roomLeaveConfirm,
    cancelLabel: context.l10n.roomCancel,
    destructive: true,
  );
  return confirmed ? LeaveChoice.end : null;
}

/// Host options for one participant (flows.md §6; 0.1.6 long-press).
Future<ParticipantAction?> showParticipantActions(
  BuildContext context,
  CallParticipant participant,
) => showGlassChoices<ParticipantAction>(
  context: context,
  title: context.l10n.roomOptionsFor(participantName(context, participant)),
  cancelLabel: context.l10n.roomCancel,
  choices: [
    if (participant.microphoneEnabled && participant.audioTrackSid != null)
      (
        label: context.l10n.roomMute,
        description: null,
        icon: Icons.mic_off,
        value: ParticipantAction.mute,
        destructive: false,
      ),
    (
      label: context.l10n.roomRemove,
      description: null,
      icon: Icons.person_remove,
      value: ParticipantAction.remove,
      destructive: true,
    ),
  ],
);

/// Remove confirmation with the ban option. Resolves to `null` when
/// cancelled, otherwise to whether the participant is banned.
Future<bool?> showRemoveParticipantDialog(
  BuildContext context,
  CallParticipant participant,
) => showGlassDialog<bool>(
  context: context,
  builder: (context) =>
      _RemoveDialog(name: participantName(context, participant)),
);

class _RemoveDialog extends StatefulWidget {
  const _RemoveDialog({required this.name});

  final String name;

  @override
  State<_RemoveDialog> createState() => _RemoveDialogState();
}

class _RemoveDialogState extends State<_RemoveDialog> {
  bool _ban = false;

  @override
  Widget build(BuildContext context) {
    return GlassDialogContent(
      title: context.l10n.roomRemoveTitle(widget.name),
      message: context.l10n.roomRemoveBody,
      body: [
        // A glass row, not an M3 list tile: the whole row toggles, black
        // check on #00AEFF (8:1).
        MergeSemantics(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _ban = !_ban),
            child: Row(
              children: [
                Checkbox(
                  value: _ban,
                  activeColor: AppColors.primary,
                  checkColor: Colors.black,
                  side: const BorderSide(color: Colors.white70, width: 2),
                  onChanged: (value) => setState(() => _ban = value ?? false),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    context.l10n.roomBan,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        GlassDialogText(
          context.l10n.roomBanNote,
          style: const TextStyle(fontSize: 13),
        ),
      ],
      actions: [
        GlassDialogButton(
          label: context.l10n.roomCancel,
          autofocus: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        GlassDialogButton(
          label: context.l10n.roomRemoveConfirm,
          style: GlassButtonStyle.destructive,
          onPressed: () => Navigator.of(context).pop(_ban),
        ),
      ],
    );
  }
}

/// Asks for a new room password ([RoomPassword]). Null when cancelled.
Future<String?> showChangePasswordDialog(BuildContext context) =>
    showGlassDialog<String>(
      context: context,
      builder: (context) => const _PasswordDialog(),
    );

class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog();

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final error = switch (RoomPassword.check(_controller.text)) {
      RoomPasswordIssue.tooShort => context.l10n.roomPasswordTooShort,
      RoomPasswordIssue.tooLong => context.l10n.roomPasswordTooLong,
      null => null,
    };
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return GlassDialogContent(
      title: context.l10n.roomPasswordDialogTitle,
      message: context.l10n.roomPasswordDialogBody,
      body: [
        // No autofill: a password manager would offer this room's
        // password on every room of the same origin.
        GlassTextField(
          controller: _controller,
          label: context.l10n.roomPasswordLabel,
          errorText: _error,
          obscure: true,
          maxLength: RoomPassword.maxLength,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _save(),
        ),
      ],
      actions: [
        GlassDialogButton(
          label: context.l10n.roomCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        GlassDialogButton(
          label: context.l10n.roomSave,
          style: GlassButtonStyle.primary,
          onPressed: _save,
        ),
      ],
    );
  }
}
