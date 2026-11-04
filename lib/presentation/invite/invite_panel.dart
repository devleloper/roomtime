import 'package:flutter/material.dart';

import '../../domain/entities/room_code.dart';
import '../dialogs/glass_dialog.dart';
import 'invite_sharing.dart';
import '../../l10n/l10n.dart';

/// Room code, link and share actions (docs/design/flows.md §3) in the
/// dev-0.1.6 dialog language. Used in the create dialog, the host's lobby
/// and the in-call invite dialog.
class InvitePanel extends StatelessWidget {
  const InvitePanel({
    super.key,
    required this.code,
    required this.inviteUrl,
    this.roomName,
    this.passwordProtected = false,
    this.onRotate,
    this.isRotating = false,
  });

  final RoomCode code;
  final Uri inviteUrl;
  final String? roomName;
  final bool passwordProtected;

  /// Host only: "Change invite code".
  final VoidCallback? onRotate;
  final bool isRotating;

  static const _label = TextStyle(
    color: Colors.white70,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final link = inviteUrl.toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (roomName != null && roomName!.isNotEmpty) ...[
          GlassDialogText(roomName!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
        ],
        Text(context.l10n.inviteCodeLabel, style: _label),
        const SizedBox(height: 4),
        Semantics(
          label: spokenRoomCode(code.display),
          excludeSemantics: true,
          child: SelectableText(
            code.display,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(context.l10n.inviteLinkLabel, style: _label),
        const SizedBox(height: 4),
        SelectableText(
          link,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        if (passwordProtected) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(child: GlassDialogText(context.l10n.invitePasswordNote)),
            ],
          ),
        ],
        const SizedBox(height: 20),
        GlassButtonRow(
          children: [
            GlassDialogButton(
              label: context.l10n.inviteCopyLink,
              icon: Icons.link,
              onPressed: () => copyWithConfirmation(
                context,
                link,
                context.l10n.inviteLinkCopied,
              ),
            ),
            GlassDialogButton(
              label: context.l10n.inviteCopyCode,
              icon: Icons.content_copy,
              onPressed: () => copyWithConfirmation(
                context,
                code.display,
                context.l10n.inviteCodeCopied,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (buttonContext) => GlassDialogButton(
            label: context.l10n.inviteShare,
            icon: Icons.ios_share,
            onPressed: () => shareInvite(buttonContext, inviteUrl),
          ),
        ),
        if (onRotate != null) ...[
          const SizedBox(height: 12),
          GlassDialogButton(
            label: context.l10n.inviteRotate,
            icon: Icons.autorenew,
            isLoading: isRotating,
            onPressed: onRotate,
          ),
        ],
      ],
    );
  }
}
