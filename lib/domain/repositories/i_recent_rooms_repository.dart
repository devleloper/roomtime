import '../entities/recent_room.dart';
import '../entities/room_code.dart';

/// Rooms this device created or joined, stored locally (no server).
abstract interface class IRecentRoomsRepository {
  /// Newest first.
  Future<List<RecentRoom>> load();

  /// Inserts or replaces the entry with the same code. The list stays sorted
  /// by `lastJoined`, newest first, so a fresh join goes to the top and a
  /// restored entry ("Undo") back to its place.
  Future<void> record(RecentRoom room);

  Future<void> remove(RoomCode code);

  /// Keeps the entry after the owner rotated the invitation code.
  Future<void> replaceCode(RoomCode oldCode, RoomCode newCode);
}
