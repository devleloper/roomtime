import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../domain/entities/recent_room.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_code.dart';
import '../../domain/repositories/i_recent_rooms_repository.dart';
import '../datasources/key_value_store.dart';

@LazySingleton(as: IRecentRoomsRepository)
class RecentRoomsRepository implements IRecentRoomsRepository {
  RecentRoomsRepository(this._store);

  static const _key = 'recent_rooms';
  static const maxEntries = 20;

  final KeyValueStore _store;

  @override
  Future<List<RecentRoom>> load() async {
    final raw = await _store.read(_key);
    if (raw == null) return const [];
    try {
      final json = jsonDecode(raw);
      if (json is! List) return const [];
      return List.unmodifiable(json.map(_decode).nonNulls);
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> record(RecentRoom room) async {
    final rooms = (await load()).where((r) => r.code != room.code).toList();
    // Before the first entry that is not newer: a fresh join (or a tie)
    // goes to the top, a restored entry back to its place.
    final index = rooms.indexWhere(
      (r) => !r.lastJoined.isAfter(room.lastJoined),
    );
    rooms.insert(index < 0 ? rooms.length : index, room);
    await _save(rooms.take(maxEntries));
  }

  @override
  Future<void> remove(RoomCode code) async {
    await _save((await load()).where((r) => r.code != code));
  }

  @override
  Future<void> replaceCode(RoomCode oldCode, RoomCode newCode) async {
    await _save(
      (await load()).map(
        (r) => r.code == oldCode
            ? RecentRoom(
                code: newCode,
                name: r.name,
                role: r.role,
                lastJoined: r.lastJoined,
              )
            : r,
      ),
    );
  }

  Future<void> _save(Iterable<RecentRoom> rooms) => _store.write(
    _key,
    jsonEncode([
      for (final r in rooms)
        {
          'code': r.code.value,
          'name': r.name,
          'role': r.role.name,
          'lastJoined': r.lastJoined.toUtc().toIso8601String(),
        },
    ]),
  );

  RecentRoom? _decode(Object? json) {
    if (json case {
      'code': String code,
      'role': String role,
      'lastJoined': String lastJoined,
    }) {
      final parsedCode = RoomCode.tryParse(code);
      final parsedRole = RoomRole.values.asNameMap()[role];
      final parsedDate = DateTime.tryParse(lastJoined);
      if (parsedCode == null || parsedRole == null || parsedDate == null) {
        return null;
      }
      final name = (json as Map)['name'];
      return RecentRoom(
        code: parsedCode,
        name: name is String ? name : null,
        role: parsedRole,
        lastJoined: parsedDate,
      );
    }
    return null;
  }
}
