import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:roomtime/data/local/key_value_store.dart';
import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/repositories/recent_rooms_repository.dart';

@LazySingleton(as: RecentRoomsRepository)
class LocalRecentRoomsRepository implements RecentRoomsRepository {
  static const _key = 'recent_rooms';
  static const maxEntries = 20;

  final KeyValueStore _store;

  LocalRecentRoomsRepository(this._store);

  @override
  Future<List<RecentRoom>> load() async {
    final raw = await _store.read(_key);
    if (raw == null) {
      return const [];
    }

    try {
      final json = jsonDecode(raw);
      if (json is! List) {
        return const [];
      }
      return List.unmodifiable(json.map(_decode).nonNulls);
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> record(RecentRoom room) async {
    final existing = await load();
    final rooms = existing.where((entry) => entry.code != room.code).toList();

    final index = rooms.indexWhere(
      (entry) => !entry.lastJoined.isAfter(room.lastJoined),
    );
    final targetIndex = index < 0 ? rooms.length : index;
    rooms.insert(targetIndex, room);

    await _save(rooms.take(maxEntries));
  }

  @override
  Future<void> remove(RoomCode code) async {
    final existing = await load();
    final remaining = existing.where((entry) => entry.code != code);
    await _save(remaining);
  }

  @override
  Future<void> replaceCode(RoomCode oldCode, RoomCode newCode) async {
    final existing = await load();
    final updated = existing.map((entry) {
      if (entry.code != oldCode) {
        return entry;
      }
      return entry.copyWith(code: newCode);
    });
    await _save(updated);
  }

  Future<void> _save(Iterable<RecentRoom> rooms) {
    final payload = jsonEncode([for (final room in rooms) room.toJson()]);
    return _store.write(_key, payload);
  }

  RecentRoom? _decode(Object? json) {
    if (json is! Map<String, dynamic>) {
      return null;
    }
    try {
      return RecentRoom.fromJson(json);
    } on Object {
      return null;
    }
  }
}
