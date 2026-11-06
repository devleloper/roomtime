import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/features/room/bloc/room_bloc.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:roomtime/presentation/widgets/invite_sharing.dart';

class CallBanners extends StatelessWidget {
  final RoomInCall state;
  final bool showReconnected;
  final bool expiryDismissed;
  final VoidCallback onLeave;
  final VoidCallback onRetryMicrophone;
  final VoidCallback onStartAudio;
  final VoidCallback onDismissExpiry;

  const CallBanners({
    super.key,
    required this.state,
    required this.showReconnected,
    required this.expiryDismissed,
    required this.onLeave,
    required this.onRetryMicrophone,
    required this.onStartAudio,
    required this.onDismissExpiry,
  });

  @override
  Widget build(BuildContext context) {
    final expiresAt = state.room.expiresAt;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state is RoomReconnecting)
          CallBannerNotice(
            message: context.l10n.roomReconnecting,
            icon: Icons.wifi_off,
            showProgress: true,
            actionLabel: context.l10n.roomLeave,
            onAction: onLeave,
          )
        else if (showReconnected)
          CallBannerNotice(
            message: context.l10n.roomReconnected,
            icon: Icons.wifi,
          ),
        if (state.call.microphoneUnavailable)
          CallBannerNotice(
            message: kIsWeb
                ? context.l10n.roomMicUnavailableWeb
                : context.l10n.roomMicUnavailable,
            icon: Icons.mic_off,
            actionLabel: context.l10n.roomTryAgain,
            onAction: onRetryMicrophone,
          ),
        if (state.call.audioPlaybackBlocked)
          CallBannerNotice(
            message: context.l10n.roomSoundBlocked,
            icon: Icons.volume_up,
            actionLabel: context.l10n.roomTurnOnSound,
            onAction: onStartAudio,
          ),
        if (state.isHost && state.expiresSoon && !expiryDismissed)
          CallBannerNotice(
            message: context.l10n.roomExpiresSoon(
              TimeOfDay.fromDateTime(expiresAt.toLocal()).format(context),
            ),
            icon: Icons.timer_outlined,
            actionLabel: context.l10n.roomDismiss,
            onAction: onDismissExpiry,
          ),
      ],
    );
  }
}

class CallBannerNotice extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showProgress;

  const CallBannerNotice({
    super.key,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: LiquidGlassContainer(
            blur: 12,
            borderRadius: 24,
            backgroundColor: Colors.black.withValues(alpha: 0.8),
            borderColor: Colors.white.withValues(alpha: 0.1),
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                if (showProgress)
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: Text(actionLabel!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CallAloneCard extends StatelessWidget {
  final Uri inviteUrl;

  const CallAloneCard({super.key, required this.inviteUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GlassPanel(
        tintAlpha: GlassPanel.overVideoTintAlpha,
        child: GlassDialogContent(
          title: context.l10n.roomAlone,
          message: context.l10n.roomAloneBody,
          actions: [
            GlassDialogButton(
              label: context.l10n.inviteCopyLink,
              icon: Icons.link,
              onPressed: () => copyWithConfirmation(
                context,
                inviteUrl.toString(),
                context.l10n.inviteLinkCopied,
              ),
            ),
            Builder(
              builder: (buttonContext) => GlassDialogButton(
                label: context.l10n.inviteShare,
                icon: Icons.ios_share,
                style: GlassButtonStyle.primary,
                onPressed: () => shareInvite(buttonContext, inviteUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
