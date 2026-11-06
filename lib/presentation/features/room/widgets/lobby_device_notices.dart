import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roomtime/domain/services/media_preview.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/widgets/glass_button.dart';
import 'package:roomtime/presentation/widgets/glass_dialog.dart';
import 'package:roomtime/presentation/widgets/participant_video.dart';

class LobbyDeviceNotices extends StatelessWidget {
  final MediaPreviewState preview;
  final bool joining;
  final bool canOpenSettings;
  final VoidCallback onRequestAccess;
  final VoidCallback onOpenSettings;

  const LobbyDeviceNotices({
    super.key,
    required this.preview,
    required this.joining,
    required this.canOpenSettings,
    required this.onRequestAccess,
    required this.onOpenSettings,
  });

  static String _cameraBlockedText(
    AppLocalizations l10n, {
    required bool canOpenSettings,
  }) {
    if (canOpenSettings) {
      return l10n.roomCameraBlocked;
    }
    if (kIsWeb) {
      return l10n.roomCameraBlockedWeb;
    }
    return l10n.roomCameraBlockedDesktop;
  }

  static String _microphoneBlockedText(
    AppLocalizations l10n, {
    required bool canOpenSettings,
  }) {
    if (canOpenSettings) {
      return l10n.roomMicBlocked;
    }
    if (kIsWeb) {
      return l10n.roomMicBlockedWeb;
    }
    return l10n.roomMicBlockedDesktop;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final micBlocked =
        preview.microphoneEnabled &&
        preview.microphoneAccess == DeviceAccess.denied;
    final cameraBlocked =
        preview.cameraEnabled && preview.cameraAccess == DeviceAccess.denied;
    final settingsLabel = canOpenSettings ? l10n.roomOpenSettings : null;
    final settingsAction = canOpenSettings ? onOpenSettings : null;

    final notices = <Widget>[
      if (preview.needsPermissionPrompt && !joining)
        _LobbyNotice(
          text: l10n.roomPermExplainer,
          actionLabel: l10n.roomPermAllow,
          onAction: onRequestAccess,
        ),
      if (cameraBlocked)
        _LobbyNotice(
          text: _cameraBlockedText(l10n, canOpenSettings: canOpenSettings),
          actionLabel: settingsLabel,
          onAction: settingsAction,
        ),
      if (micBlocked)
        _LobbyNotice(
          text: _microphoneBlockedText(l10n, canOpenSettings: canOpenSettings),
          actionLabel: settingsLabel,
          onAction: settingsAction,
        ),
    ];

    if (notices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final notice in notices) ...[const SizedBox(height: 16), notice],
      ],
    );
  }
}

class _LobbyNotice extends StatelessWidget {
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _LobbyNotice({required this.text, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          liveRegion: true,
          child: GlassDialogText(text, textAlign: TextAlign.center),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 8),
          GlassDialogButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    );
  }
}

class LobbyBackdrop extends StatelessWidget {
  final MediaPreviewState preview;
  final String name;

  const LobbyBackdrop({super.key, required this.preview, required this.name});

  @override
  Widget build(BuildContext context) {
    final cameraOn = preview.cameraEnabled;
    final showVideo = cameraOn && preview.videoTrack != null;
    return Semantics(
      container: true,
      label: cameraOn
          ? context.l10n.roomPreviewOn
          : context.l10n.roomPreviewOff,
      child: showVideo
          ? ParticipantVideo(videoTrack: preview.videoTrack, name: name)
          : const ColoredBox(color: Colors.black),
    );
  }
}
