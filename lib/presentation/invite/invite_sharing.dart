import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../l10n/l10n.dart';
import '../widgets/widgets.dart';

/// Copies [text] and confirms with a glass HUD pill on the root overlay,
/// so it shows above an open dialog (F4; a SnackBar sits under the dialog
/// barrier). The pill is a live region. A refused clipboard (e.g. Safari
/// after the user gesture expired) shows no confirmation and throws nothing.
Future<void> copyWithConfirmation(
  BuildContext context,
  String text,
  String confirmation,
) async {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  try {
    await Clipboard.setData(ClipboardData(text: text));
  } on Object catch (error) {
    developer.log(
      'clipboard unavailable: $error',
      name: 'copyWithConfirmation',
    );
    return;
  }
  if (overlay == null || !overlay.mounted) return;
  _CopiedHud.show(overlay, confirmation);
}

/// How long the copy confirmation stays up.
@visibleForTesting
const copiedHudDuration = Duration(seconds: 2);

/// The 0.1.6 HUD pill (glass, black @ 0.7, `check_circle`) near the top of
/// the screen. One at a time: a new confirmation replaces the shown one.
abstract final class _CopiedHud {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(OverlayState overlay, String message) {
    _hide();
    final entry = _entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 16,
        left: 16,
        right: 16,
        child: IgnorePointer(
          child: Center(
            child: Semantics(
              liveRegion: true,
              child: LiquidGlassContainer(
                blur: 12,
                borderRadius: 100,
                backgroundColor: Colors.black.withValues(alpha: 0.7),
                borderColor: Colors.white.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    _timer = Timer(copiedHudDuration, _hide);
  }

  static void _hide() {
    _timer?.cancel();
    _timer = null;
    final entry = _entry;
    _entry = null;
    if (entry == null) return;
    // [_entry] is set only right after `overlay.insert`, so it is always in
    // an overlay here. `mounted` is not that: it turns true only once the
    // entry has been built, so a second copy within the same frame used to
    // skip the removal and leave a disposed pill on screen.
    entry
      ..remove()
      ..dispose();
  }
}

/// Whether a share that returned [result] is finished. On web, share_plus
/// reports a completed Web Share as `unavailable`, so only an exception
/// means "no sharing here" there.
@visibleForTesting
bool shareFinished(ShareResult result, {bool web = kIsWeb}) =>
    web || result.status != ShareResultStatus.unavailable;

/// Opens the system share sheet (Web Share API on web). Where sharing is not
/// available, copies the link instead. The password is never part of it.
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
    if (shareFinished(result)) return;
  } on Object catch (error) {
    developer.log('share unavailable: $error', name: 'shareInvite');
  }
  if (!context.mounted) return;
  await copyWithConfirmation(context, link, context.l10n.inviteLinkCopied);
}

/// Spells a room code letter by letter so screen readers do not read it as
/// a word: `abc-defg` becomes `a b c, d e f g`.
String spokenRoomCode(String display) =>
    display.split('-').map((group) => group.split('').join(' ')).join(', ');
