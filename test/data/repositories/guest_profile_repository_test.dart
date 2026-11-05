import 'dart:math';

import 'package:roomtime/data/repositories/guest_profile_repository.dart';
import 'package:roomtime/data/repositories/recent_rooms_repository.dart';
import 'package:roomtime/domain/entities/recent_room.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

final uuidV4Pattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

void main() {
  group('GuestProfileRepository', () {
    test('creates a v4 guestId once and keeps it across instances', () async {
      final store = InMemoryKeyValueStore();

      final first = await GuestProfileRepository(store).load();
      final second = await GuestProfileRepository(store).load();

      expect(first.guestId, matches(uuidV4Pattern));
      expect(second.guestId, first.guestId);
      expect(first.displayName, isEmpty);
    });

    // concurrent first loads share one guestId.
    test('parallel first loads create one guestId, the stored one', () async {
      final store = InMemoryKeyValueStore();
      final repository = GuestProfileRepository(store);

      final results = await Future.wait([repository.load(), repository.load()]);

      expect(results[0].guestId, results[1].guestId);
      final again = await GuestProfileRepository(store).load();
      expect(again.guestId, results[0].guestId);
    });

    test('different random sources give different ids', () {
      expect(uuidV4(Random(1)), isNot(uuidV4(Random(2))));
      expect(uuidV4(Random(1)), matches(uuidV4Pattern));
    });

    test('saves a trimmed display name', () async {
      final store = InMemoryKeyValueStore();
      final repository = GuestProfileRepository(store);
      final id = (await repository.load()).guestId;

      await repository.updateDisplayName('  Ann  ');

      final reloaded = await GuestProfileRepository(store).load();
      expect(reloaded.displayName, 'Ann');
      expect(reloaded.guestId, id);
    });

    test('rejects empty and too long names', () async {
      final repository = GuestProfileRepository(InMemoryKeyValueStore());

      expect(() => repository.updateDisplayName('   '), throwsArgumentError);
      expect(() => repository.updateDisplayName('x' * 33), throwsArgumentError);
    });

    test('replaces a corrupt entry with a new identity', () async {
      final store = InMemoryKeyValueStore()
        ..values['guest_profile'] = '{"guestId": "not-a-uuid"}';

      final profile = await GuestProfileRepository(store).load();

      expect(profile.guestId, matches(uuidV4Pattern));
    });
  });

  group('RecentRoomsRepository', () {
    RecentRoom room(String code, int day) => RecentRoom(
      code: RoomCode.tryParse(code)!,
      role: RoomRole.participant,
      lastJoined: DateTime.utc(2026, 11, day),
    );

    test('keeps newest first, deduplicated by code, capped', () async {
      final repository = RecentRoomsRepository(InMemoryKeyValueStore());

      await repository.record(room('abcdefghjk', 1));
      await repository.record(room('mnpqrstuvw', 2));
      await repository.record(room('abcdefghjk', 3));

      final rooms = await repository.load();
      expect(rooms.map((r) => r.code.value), ['abcdefghjk', 'mnpqrstuvw']);
      expect(rooms.first.lastJoined, DateTime.utc(2026, 11, 3));

      const alphabet = RoomCode.alphabet;
      for (var i = 0; i < RecentRoomsRepository.maxEntries + 5; i++) {
        final code = 'mnpqrstu${alphabet[i % 23]}${alphabet[i ~/ 23]}';
        await repository.record(room(code, 4));
      }
      final capped = await repository.load();
      expect(capped.length, RecentRoomsRepository.maxEntries);
      expect(capped.first.code.value, 'mnpqrstu${alphabet[1]}${alphabet[1]}');
    });

    // Undo records the removed entry again, back in its place.
    test('a restored entry goes back to its place by lastJoined', () async {
      final repository = RecentRoomsRepository(InMemoryKeyValueStore());
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

    test('ignores corrupt storage', () async {
      final store = InMemoryKeyValueStore()..values['recent_rooms'] = '{oops';

      expect(await RecentRoomsRepository(store).load(), isEmpty);
    });
  });
}
