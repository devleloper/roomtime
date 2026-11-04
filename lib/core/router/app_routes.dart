import 'package:flutter/foundation.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/room_code.dart';

/// Route paths. Only the room code ever appears in a URL; everything else
/// travels in typed `extra` objects (memory only, lost on reload).
abstract final class AppRoutes {
  static const home = '/';

  /// Invite link path, also the deep link target: `/r/<code>`.
  static const roomPattern = '/r/:code';

  static String room(RoomCode code) => '/r/${code.value}';

  /// Guard for [roomPattern]: `null` keeps a canonical code, other spellings
  /// (`ABC-DEFG-HJK`) go to the canonical path, and a malformed code goes
  /// straight [home] with [HomeNotice.invalidInviteLink] posted to [notices],
  /// so no room frame is ever built for it.
  static String? roomRedirect(String raw, PendingHomeNotice notices) {
    final code = RoomCode.tryParse(raw);
    if (code == null) {
      notices.post(HomeNotice.invalidInviteLink);
      return home;
    }
    return code.value == raw ? null : room(code);
  }
}

/// Typed, in-memory arguments for the room route.
final class RoomRouteExtra {
  const RoomRouteExtra({this.summary});

  /// Lookup result from Home, so the lobby does not ask again.
  final RoomSummary? summary;
}

/// Typed, in-memory arguments for the home route.
final class HomeRouteExtra {
  const HomeRouteExtra({this.openCreateSheet = false});

  /// Opens the New room sheet on arrival ("New room" on the Ended screen).
  final bool openCreateSheet;
}

/// One-shot message Home shows on arrival.
enum HomeNotice { invalidInviteLink }

/// Hands a [HomeNotice] from a redirect (which cannot pass `extra`) to Home,
/// whether Home is built next or already shown (listeners are told). [take]
/// returns it once.
final class PendingHomeNotice extends ChangeNotifier {
  HomeNotice? _notice;

  void post(HomeNotice notice) {
    _notice = notice;
    notifyListeners();
  }

  HomeNotice? take() {
    final notice = _notice;
    _notice = null;
    return notice;
  }
}
