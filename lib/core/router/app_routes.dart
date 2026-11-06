import 'package:flutter/foundation.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';

abstract final class AppRoutes {
  static const home = '/';

  static const roomPattern = '/r/:code';

  static String room(RoomCode code) => '/r/${code.value}';

  static String? roomRedirect(String raw, PendingHomeNotice notices) {
    final code = RoomCode.tryParse(raw);
    if (code == null) {
      notices.post(HomeNotice.invalidInviteLink);
      return home;
    }

    // Redirect non-canonical input (e.g. uppercase) to the canonical room URL.
    if (code.value == raw) {
      return null;
    }
    return room(code);
  }
}

final class RoomRouteExtra {
  final RoomSummary? summary;

  const RoomRouteExtra({this.summary});
}

final class HomeRouteExtra {
  final bool openCreateSheet;

  const HomeRouteExtra({this.openCreateSheet = false});
}

enum HomeNotice { invalidInviteLink }

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
