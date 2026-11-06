import 'package:flutter/widgets.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/l10n/l10n.dart';

String roomTitle(BuildContext context, String? name, RoomCode code) {
  if (name == null || name.isEmpty) {
    return context.l10n.roomTitleUnnamed(code.display);
  }
  return name;
}
