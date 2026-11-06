import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomtime/domain/entities/call_snapshot.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/features/room/widgets/host_dialogs.dart';
import 'package:roomtime/presentation/features/room/widgets/participant_tile.dart';
import 'package:roomtime/presentation/theme/app_colors.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';
import 'package:roomtime/presentation/widgets/initials_avatar.dart';

Future<void> runParticipantActions(
  BuildContext context,
  CallParticipant participant,
) async {
  final bloc = context.read<RoomBloc>();
  final action = await showParticipantActions(context, participant);
  if (action == null || !context.mounted) {
    return;
  }
  switch (action) {
    case ParticipantAction.mute:
      final trackSid = participant.audioTrackSid;
      if (trackSid == null) {
        return;
      }
      bloc.add(
        RoomParticipantMuteRequested(
          identity: participant.identity,
          trackSid: trackSid,
        ),
      );
    case ParticipantAction.remove:
      final ban = await showRemoveParticipantDialog(context, participant);
      if (ban == null) {
        return;
      }
      bloc.add(
        RoomParticipantRemoveRequested(
          identity: participant.identity,
          ban: ban,
        ),
      );
  }
}

Future<void> confirmRotateInvite(BuildContext context) async {
  final bloc = context.read<RoomBloc>();
  final confirmed = await showGlassConfirm(
    context: context,
    title: context.l10n.inviteRotateTitle,
    message: context.l10n.inviteRotateBody,
    confirmLabel: context.l10n.inviteRotateConfirm,
    cancelLabel: context.l10n.inviteCancel,
  );
  if (confirmed) {
    bloc.add(const RoomInviteRotateRequested());
  }
}

class ParticipantsPanel extends StatelessWidget {
  const ParticipantsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      buildWhen: (previous, current) => current is RoomInCall,
      builder: (context, state) {
        if (state is! RoomInCall) {
          return const SizedBox.shrink();
        }
        final participants = state.call.participants;
        return GlassDialogContent(
          title: context.l10n.roomPeopleTitle(participants.length),
          body: [
            if (state.isHost) _HostControls(state: state),
            for (final p in participants)
              _ParticipantRow(
                key: ValueKey(p.id),
                participant: p,
                isLocalHost: state.isHost,
                showActions: state.isHost && !p.isLocal,
              ),
          ],
          actions: [
            GlassDialogButton(
              label: context.l10n.roomClose,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class _HostControls extends StatelessWidget {
  final RoomInCall state;

  const _HostControls({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RoomBloc>();
    final hasPassword = state.room.passwordRequired;
    final locked = state.room.locked;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            context.l10n.roomRoomSettings,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        MergeSemantics(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => bloc.add(RoomLockRequested(!locked)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: Colors.white70),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RowText(
                      title: context.l10n.roomLock,
                      subtitle: context.l10n.roomLockSub,
                    ),
                  ),
                  Switch(
                    value: locked,
                    activeTrackColor: AppColors.primary,
                    activeThumbColor: Colors.black,
                    onChanged: (value) => bloc.add(RoomLockRequested(value)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        GlassDialogButton(
          label: hasPassword
              ? context.l10n.roomChangePassword
              : context.l10n.roomSetPassword,
          icon: Icons.password,
          onPressed: () async {
            final password = await showChangePasswordDialog(context);
            if (password != null) {
              bloc.add(RoomPasswordChangeRequested(password));
            }
          },
        ),
        if (hasPassword) ...[
          const SizedBox(height: 12),
          GlassDialogButton(
            label: context.l10n.roomRemovePassword,
            icon: Icons.lock_open,
            onPressed: () async {
              final confirmed = await showGlassConfirm(
                context: context,
                title: context.l10n.roomRemovePasswordTitle,
                message: context.l10n.roomRemovePasswordBody,
                confirmLabel: context.l10n.roomRemovePasswordConfirm,
                cancelLabel: context.l10n.roomCancel,
              );
              if (confirmed) {
                bloc.add(const RoomPasswordChangeRequested(null));
              }
            },
          ),
        ],
        const SizedBox(height: 12),
        GlassDialogButton(
          label: context.l10n.inviteRotate,
          icon: Icons.autorenew,
          onPressed: () => confirmRotateInvite(context),
        ),
        const SizedBox(height: 16),
        Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
      ],
    );
  }
}

class _RowText extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _RowText({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle case final subtitle?) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ],
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final CallParticipant participant;
  final bool isLocalHost;
  final bool showActions;

  const _ParticipantRow({
    super.key,
    required this.participant,
    required this.isLocalHost,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    final name = participantName(context, participant);
    final subtitle = [
      if (participant.isLocal) context.l10n.roomYou,
      if (participant.isLocal && isLocalHost) context.l10n.roomHost,
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: MergeSemantics(
                child: Row(
                  children: [
                    InitialsAvatar(name: name, colorSeed: participant.identity),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RowText(
                        title: name,
                        subtitle: subtitle.isEmpty ? null : subtitle.join(', '),
                      ),
                    ),
                    Icon(
                      participant.microphoneEnabled ? Icons.mic : Icons.mic_off,
                      color: participant.microphoneEnabled
                          ? Colors.white70
                          : AppColors.error,
                      semanticLabel: participant.microphoneEnabled
                          ? context.l10n.roomMicOn
                          : context.l10n.roomMicOff,
                    ),
                  ],
                ),
              ),
            ),
            if (showActions)
              IconButton(
                tooltip: context.l10n.roomOptionsFor(name),
                color: Colors.white,
                icon: const Icon(Icons.more_vert),
                onPressed: () => runParticipantActions(context, participant),
              ),
          ],
        ),
      ),
    );
  }
}
