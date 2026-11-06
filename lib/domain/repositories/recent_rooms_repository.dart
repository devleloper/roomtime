import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room_code.dart';

abstract interface class RecentRoomsRepository {
  Future<List<RecentRoom>> load();

  Future<void> record(RecentRoom room);

  Future<void> remove(RoomCode code);

  Future<void> replaceCode(RoomCode oldCode, RoomCode newCode);
}
