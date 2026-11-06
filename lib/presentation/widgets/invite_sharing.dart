import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/l10n/l10n.dart';
import 'package:roomtime/presentation/widgets/glass_surface.dart';
import 'package:share_plus/share_plus.dart';

@visibleForTesting
const copiedHudDuration = Duration(seconds: 2);

Future<void> copyWithConfirmation(
  BuildContext context,
  String text,
  String confirmation,
) async {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  try {
    await Clipboard.setData(ClipboardData(text: text));
  } on Object catch (error) {
    devLog(
      'clipboard unavailable: $error',
      name: 'copyWithConfirmation',
      error: error,
    );
    return;
  }

  if (overlay == null || !overlay.mounted) {
    return;
  }
  _CopiedHud.show(overlay, confirmation);
}

abstract final class _CopiedHud {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(OverlayState overlay, String message) {
    _hide();
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 16,
        right: 16,
        child: IgnorePointer(
          child: Center(
            child: GlassHudPill(icon: Icons.check_circle, message: message),
          ),
        ),
      ),
    );
    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(copiedHudDuration, _hide);
  }

  static void _hide() {
    _timer?.cancel();
    _timer = null;

    final entry = _entry;
    _entry = null;
    if (entry == null) {
      return;
    }

    entry.remove();
    entry.dispose();
  }
}

@visibleForTesting
bool shareFinished(ShareResult result, {bool web = kIsWeb}) {
  return web || result.status != ShareResultStatus.unavailable;
}

Future<void> shareInvite(BuildContext context, Uri inviteUrl) async {
  final box = context.findRenderObject() as RenderBox?;
  final origin = box != null && box.hasSize
      ? box.localToGlobal(Offset.zero) & box.size
      : null;
  final link = inviteUrl.toString();

  try {
    final result = await SharePlus.instance.share(
      ShareParams(
        text: context.l10n.inviteShareText(link),
        subject: context.l10n.inviteShareSubject,
        sharePositionOrigin: origin,
        mailToFallbackEnabled: false,
      ),
    );
    if (shareFinished(result)) {
      return;
    }
  } on Object catch (error) {
    devLog('share unavailable: $error', name: 'shareInvite', error: error);
  }

  if (!context.mounted) {
    return;
  }
  await copyWithConfirmation(context, link, context.l10n.inviteLinkCopied);
}

String spokenRoomCode(String display) {
  return display
      .split('-')
      .map((group) => group.split('').join(' '))
      .join(', ');
}
