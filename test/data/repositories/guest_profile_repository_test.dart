import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/data/local/key_value_store.dart';
import 'package:roomtime/data/repositories/guest_profile_repository.dart';
import 'package:roomtime/data/repositories/recent_rooms_repository.dart';
import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';

import '../../helpers/fakes.dart';

final uuidV4Pattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  group('LocalGuestProfileRepository', () {
    test('creates a v4 guestId once and keeps it across instances', () async {
      final store = InMemoryKeyValueStore();

      final first = await LocalGuestProfileRepository(store).load();
      final second = await LocalGuestProfileRepository(store).load();

      expect(first.guestId, matches(uuidV4Pattern));
      expect(second.guestId, first.guestId);
      expect(first.displayName, isEmpty);
    });

    test('parallel first loads create one guestId, the stored one', () async {
      final store = InMemoryKeyValueStore();
      final repository = LocalGuestProfileRepository(store);

      final results = await Future.wait([repository.load(), repository.load()]);

      expect(results[0].guestId, results[1].guestId);
      final again = await LocalGuestProfileRepository(store).load();
      expect(again.guestId, results[0].guestId);
    });

    test('different random sources give different ids', () {
      expect(uuidV4(Random(1)), isNot(uuidV4(Random(2))));
      expect(uuidV4(Random(1)), matches(uuidV4Pattern));
    });

    test('saves a trimmed display name', () async {
      final store = InMemoryKeyValueStore();
      final repository = LocalGuestProfileRepository(store);
      final id = (await repository.load()).guestId;

      await repository.updateDisplayName('  Ann  ');

      final reloaded = await LocalGuestProfileRepository(store).load();
      expect(reloaded.displayName, 'Ann');
      expect(reloaded.guestId, id);
    });

    test('rejects empty and too long names', () async {
      final repository = LocalGuestProfileRepository(InMemoryKeyValueStore());

      expect(() => repository.updateDisplayName('   '), throwsArgumentError);
      expect(() => repository.updateDisplayName('x' * 33), throwsArgumentError);
    });

    test('replaces a corrupt entry with a new identity', () async {
      final store = InMemoryKeyValueStore()
        ..values['guest_profile'] = '{"guestId": "not-a-uuid"}';

      final profile = await LocalGuestProfileRepository(store).load();

      expect(profile.guestId, matches(uuidV4Pattern));
    });

    test(
      'clears in-flight loading state after a storage failure so retry succeeds',
      () async {
        final baseStore = InMemoryKeyValueStore();
        var shouldFail = true;
        final store = _FlakyReadStore(baseStore, shouldFail: () => shouldFail);
        final repository = LocalGuestProfileRepository(store);

        await expectLater(repository.load(), throwsStateError);

        shouldFail = false;
        final profile = await repository.load();
        expect(profile.guestId, matches(uuidV4Pattern));
      },
    );
  });

  group('LocalRecentRoomsRepository', () {
    RecentRoom room(String code, int day) => RecentRoom(
      code: RoomCode.tryParse(code)!,
      role: RoomRole.participant,
      lastJoined: DateTime.utc(2026, 11, day),
    );

    test('keeps newest first, deduplicated by code, capped', () async {
      final repository = LocalRecentRoomsRepository(InMemoryKeyValueStore());

      await repository.record(room('abcdefghjk', 1));
      await repository.record(room('mnpqrstuvw', 2));
      await repository.record(room('abcdefghjk', 3));

      final rooms = await repository.load();
      expect(rooms.map((r) => r.code.value), ['abcdefghjk', 'mnpqrstuvw']);
      expect(rooms.first.lastJoined, DateTime.utc(2026, 11, 3));

      const alphabet = RoomCode.alphabet;
      for (var i = 0; i < LocalRecentRoomsRepository.maxEntries + 5; i++) {
        final code = 'mnpqrstu${alphabet[i % 23]}${alphabet[i ~/ 23]}';
        await repository.record(room(code, 4));
      }
      final capped = await repository.load();
      expect(capped.length, LocalRecentRoomsRepository.maxEntries);
      expect(capped.first.code.value, 'mnpqrstu${alphabet[1]}${alphabet[1]}');
    });

    test('a restored entry goes back to its place by lastJoined', () async {
      final repository = LocalRecentRoomsRepository(InMemoryKeyValueStore());
      await repository.record(room('abcdefghjk', 1));
      await repository.record(room('mnpqrstuvw', 2));
      await repository.record(room('qrstuvwxyz', 3));

      final removed = (await repository.load())[1];
      await repository.remove(removed.code);
      await repository.record(removed);

      expect((await repository.load()).map((r) => r.code.value), [
        'qrstuvwxyz',
        'mnpqrstuvw',
        'abcdefghjk',
      ]);
    });

    test('stores lastJoined in UTC', () async {
      final store = InMemoryKeyValueStore();
      final repository = LocalRecentRoomsRepository(store);
      final joined = DateTime(2026, 11, 6, 12);

      await repository.record(
        RecentRoom(
          code: RoomCode.tryParse('abcdefghjk')!,
          role: RoomRole.host,
          lastJoined: joined,
        ),
      );

      final stored = jsonDecode(store.values['recent_rooms']!) as List;
      expect((stored.single as Map)['lastJoined'], endsWith('Z'));
      final loaded = (await repository.load()).single.lastJoined;
      expect(loaded.isAtSameMomentAs(joined), isTrue);
    });

    test('ignores corrupt storage', () async {
      final store = InMemoryKeyValueStore()..values['recent_rooms'] = '{oops';

      expect(await LocalRecentRoomsRepository(store).load(), isEmpty);
    });

    test('replaceCode updates only the matching room code in place', () async {
      final repository = LocalRecentRoomsRepository(InMemoryKeyValueStore());
      final first = RecentRoom(
        code: RoomCode.tryParse('abcdefghjk')!,
        name: 'Family',
        role: RoomRole.host,
        lastJoined: DateTime.utc(2026, 11, 2),
      );
      final second = room('mnpqrstuvw', 1);
      await repository.record(first);
      await repository.record(second);

      final rotated = RoomCode.tryParse('zyxwvutsrq')!;
      await repository.replaceCode(first.code, rotated);

      final loaded = await repository.load();
      expect(loaded, [
        RecentRoom(
          code: rotated,
          name: 'Family',
          role: RoomRole.host,
          lastJoined: DateTime.utc(2026, 11, 2),
        ),
        second,
      ]);
    });
  });
}

class _FlakyReadStore implements KeyValueStore {
  _FlakyReadStore(this._delegate, {required this.shouldFail});

  final InMemoryKeyValueStore _delegate;
  final bool Function() shouldFail;

  @override
  Future<String?> read(String key) async {
    if (shouldFail()) {
      throw StateError('transient read failure');
    }
    return _delegate.read(key);
  }

  @override
  Future<void> write(String key, String value) => _delegate.write(key, value);

  @override
  Future<void> delete(String key) => _delegate.delete(key);

  @override
  Future<Map<String, String>> readAll() => _delegate.readAll();
}
