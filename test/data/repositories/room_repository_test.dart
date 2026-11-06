import 'package:dio/dio.dart';
import 'package:roomtime/data/local/owner_token_store.dart';
import 'package:roomtime/data/network/room_api_data_source.dart';
import 'package:roomtime/data/repositories/recent_rooms_repository.dart';
import 'package:roomtime/data/repositories/room_repository.dart';
import 'package:roomtime/domain/entities/guest_profile.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:roomtime/domain/entities/room_code.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

const guest = GuestProfile(
  guestId: '6f1c1a7e-3b0a-4c55-9d1e-2b8f0f4f7a10',
  displayName: 'Ann',
);

const createdJson = {
  'roomId': 'l6lehhbfpqujofffzs4semv4ry',
  'code': 'abcdefghjk',
  'inviteUrl': 'https://calls.example.com/r/abc-defg-hjk',
  'ownerToken': 'owner-secret',
  'name': 'Family',
  'passwordRequired': true,
  'e2ee': false,
  'locked': false,
  'maxParticipants': 10,
  'expiresAt': '2030-01-01T00:00:00Z',
};

Map<String, Object?> joinJson({String role = 'participant'}) => {
  'token': 'lk-token',
  'livekitUrl': 'wss://media.example.com',
  'identity': 'p_k3j5x2m7q4r6t8v2w3y5',
  'role': role,
  'room': {
    'code': 'abcdefghjk',
    'inviteUrl': 'https://calls.example.com/r/abc-defg-hjk',
    'name': 'Family',
    'passwordRequired': false,
    'e2ee': false,
    'locked': false,
    'maxParticipants': 10,
    'expiresAt': '2030-01-01T00:00:00Z',
  },
};

void main() {
  late FakeHttpAdapter http;
  late InMemoryKeyValueStore store;
  late LocalRecentRoomsRepository recents;
  late ApiRoomRepository repository;
  late FakeResponse Function(String method, String path) respond;
  final clock = FixedClock(DateTime.utc(2026, 11, 3, 12));

  setUp(() {
    respond = (_, _) => const FakeResponse(500);
    http = FakeHttpAdapter((r) => respond(r.method, r.uri.path));
    store = InMemoryKeyValueStore();
    recents = LocalRecentRoomsRepository(store);
    repository = ApiRoomRepository(
      RoomApiDataSource(fakeDio(http)),
      OwnerTokenStore(store),
      recents,
      clock,
    );
  });

  String? authorization(int index) =>
      http.requests[index].headers['Authorization'] as String?;

  group('createRoom', () {
    test('posts only the given fields, stores the owner token, records the '
        'room as host', () async {
      respond = (method, path) => method == 'POST' && path == '/v1/rooms'
          ? const FakeResponse(201, createdJson)
          : const FakeResponse(404);

      final room = await repository.createRoom(
        const CreateRoomParams(name: 'Family', password: 'secret'),
      );

      final request = http.requests.single;
      expect(request.headers['content-type'], contains('application/json'));

      expect(http.requests.single.data, {
        'name': 'Family',
        'password': 'secret',
      });
      expect(room.code, testCode);
      expect(room.inviteUrl, Uri.parse(createdJson['inviteUrl']! as String));
      expect(room.passwordRequired, isTrue);
      expect(await repository.isOwner(testCode), isTrue);
      final recent = (await recents.load()).single;
      expect(recent.role, RoomRole.host);
      expect(recent.lastJoined, clock.current);
      expect(store.values.values.join(), contains('owner-secret'));
    });

    test('a malformed 201 is an UnknownFailure, nothing is stored', () async {
      respond = (_, _) => const FakeResponse(201, {'roomId': 'x'});

      await expectLater(
        repository.createRoom(const CreateRoomParams()),
        throwsA(isA<UnknownFailure>()),
      );
      expect(store.values, isEmpty);
    });
  });

  group('lookup', () {
    test('parses the summary', () async {
      respond = (method, path) => path == '/v1/rooms/abcdefghjk'
          ? const FakeResponse(200, {
              'code': 'abcdefghjk',
              'inviteUrl': 'https://calls.example.com/r/abc-defg-hjk',
              'passwordRequired': true,
              'e2ee': false,
              'locked': false,
              'expiresAt': '2030-01-01T00:00:00Z',
            })
          : const FakeResponse(404);

      final summary = await repository.lookup(testCode);

      expect(summary.name, isNull);
      expect(summary.passwordRequired, isTrue);
      expect(summary.expiresAt, DateTime.utc(2030));
      expect(
        summary.inviteUrl,
        Uri.parse('https://calls.example.com/r/abc-defg-hjk'),
      );
    });

    test('404 room_not_found -> RoomNotFoundFailure', () async {
      respond = (_, _) =>
          const FakeResponse(404, {'status': 404, 'code': 'room_not_found'});

      await expectLater(
        repository.lookup(testCode),
        throwsA(const RoomNotFoundFailure()),
      );
    });

    test('a non-object body is an UnknownFailure', () async {
      respond = (_, _) => const FakeResponse(200, ['not', 'an', 'object']);

      await expectLater(
        repository.lookup(testCode),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('an invalid code in the body is an UnknownFailure', () async {
      respond = (_, _) => const FakeResponse(200, {
        'code': 'not-a-code',
        'passwordRequired': false,
      });

      await expectLater(
        repository.lookup(testCode),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  test('create and join send the password verbatim', () async {
    const typed = ' Pa\u00A0ss\tÄ ';
    respond = (method, path) => switch (path) {
      '/v1/rooms' => const FakeResponse(201, createdJson),
      '/v1/rooms/abcdefghjk/join' => FakeResponse(200, joinJson()),
      _ => const FakeResponse(404),
    };

    await repository.createRoom(const CreateRoomParams(password: typed));
    await repository.join(testCode, guest: guest, password: typed);

    expect((http.requests[0].data as Map)['password'], typed);
    expect((http.requests[1].data as Map)['password'], typed);
  });

  group('join', () {
    test('sends name, guestId and password in the body, no bearer without '
        'an owner token, records the room', () async {
      respond = (method, path) => path == '/v1/rooms/abcdefghjk/join'
          ? FakeResponse(200, joinJson())
          : const FakeResponse(404);

      final join = await repository.join(
        testCode,
        guest: guest,
        password: 'secret',
      );

      final request = http.requests.single;
      expect(request.headers['content-type'], contains('application/json'));
      expect(request.method, 'POST');
      expect(request.uri.query, isEmpty, reason: 'no secrets in the URL');
      expect(request.data, {
        'displayName': 'Ann',
        'guestId': guest.guestId,
        'password': 'secret',
      });
      expect(authorization(0), isNull);
      expect(join.role, RoomRole.participant);
      expect(join.livekitUrl, 'wss://media.example.com');
      expect(join.room.code, testCode);
      expect((await recents.load()).single.code, testCode);
    });

    test('an unnamed guest joins with the default display name', () async {
      respond = (_, _) => FakeResponse(200, joinJson());

      await repository.join(testCode, guest: guest.copyWith(displayName: ''));

      expect(
        (http.requests.single.data as Map)['displayName'],
        GuestProfile.defaultDisplayName,
      );
    });

    test('sends the owner token as Bearer after create', () async {
      respond = (method, path) => path == '/v1/rooms'
          ? const FakeResponse(201, createdJson)
          : FakeResponse(200, joinJson(role: 'host'));

      await repository.createRoom(const CreateRoomParams());
      final join = await repository.join(testCode, guest: guest);

      expect(authorization(1), 'Bearer owner-secret');
      expect(join.role, RoomRole.host);
    });

    final failures = <(int, String, Failure)>[
      (401, 'password_required', const PasswordRequiredFailure()),
      (403, 'invalid_password', const InvalidPasswordFailure()),
      (404, 'room_not_found', const RoomNotFoundFailure()),
      (409, 'room_full', const RoomFullFailure()),
      (423, 'room_locked', const RoomLockedFailure()),
      (403, 'participant_banned', const ParticipantBannedFailure()),
    ];
    for (final (status, code, failure) in failures) {
      test('$status $code -> ${failure.runtimeType}', () async {
        respond = (_, _) =>
            FakeResponse(status, {'status': status, 'code': code});

        await expectLater(
          repository.join(testCode, guest: guest),
          throwsA(failure),
        );
        expect(await recents.load(), isEmpty);
      });
    }

    test('429 with Retry-After', () async {
      respond = (_, _) => const FakeResponse(
        429,
        {'status': 429, 'code': 'too_many_attempts'},
        {'retry-after': '30'},
      );

      await expectLater(
        repository.join(testCode, guest: guest, password: 'x'),
        throwsA(
          const TooManyAttemptsFailure(retryAfter: Duration(seconds: 30)),
        ),
      );
    });

    test('an unknown role is an UnknownFailure', () async {
      respond = (_, _) => FakeResponse(200, joinJson(role: 'admin'));

      await expectLater(
        repository.join(testCode, guest: guest),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('a missing token is an UnknownFailure', () async {
      respond = (_, _) => FakeResponse(200, {...joinJson()}..remove('token'));

      await expectLater(
        repository.join(testCode, guest: guest),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  group('owner actions', () {
    setUp(() async {
      respond = (_, _) => const FakeResponse(201, createdJson);
      await repository.createRoom(const CreateRoomParams());
      http.requests.clear();
    });

    test('without an owner token they fail before any request', () async {
      final other = RoomCode.tryParse('zyxwvutsrq')!;

      await expectLater(
        repository.endRoom(other),
        throwsA(const ForbiddenFailure()),
      );
      expect(http.requests, isEmpty);
    });

    test('end sends the bearer, then forgets the token and the room', () async {
      respond = (method, path) =>
          method == 'POST' && path == '/v1/rooms/abcdefghjk/end'
          ? const FakeResponse(204)
          : const FakeResponse(404);

      await repository.endRoom(testCode);

      expect(authorization(0), 'Bearer owner-secret');
      expect(await repository.isOwner(testCode), isFalse);
      expect(await recents.load(), isEmpty);
    });

    test('mute and remove address the participant identity', () async {
      respond = (_, _) => const FakeResponse(204);

      await repository.muteParticipant(
        testCode,
        identity: 'p_bob',
        trackSid: 'TR_1',
      );
      await repository.removeParticipant(
        testCode,
        identity: 'p_bob',
        ban: true,
      );

      expect(
        http.requests[0].uri.path,
        '/v1/rooms/abcdefghjk/participants/p_bob/mute',
      );
      expect(http.requests[0].data, {'trackSid': 'TR_1'});
      expect(
        http.requests[1].uri.path,
        '/v1/rooms/abcdefghjk/participants/p_bob/remove',
      );
      expect(http.requests[1].data, {'ban': true});
      expect(authorization(1), 'Bearer owner-secret');
    });

    test('patch sends null to remove the password', () async {
      respond = (_, _) => const FakeResponse(200, createdJson);

      await repository.updateRoom(
        testCode,
        const RoomPatch(locked: true, password: RemovePassword()),
      );

      expect(http.requests.single.method, 'PATCH');
      expect(http.requests.single.data, {'locked': true, 'password': null});
    });

    test('rotate-code moves the token and the recent entry to the new '
        'code', () async {
      respond = (_, _) => const FakeResponse(200, {
        'code': 'mnpqrstuvw',
        'roomId': 'l6lehhbfpqujofffzs4semv4ry',
        'inviteUrl': 'https://calls.example.com/r/mnp-qrst-uvw',
        'passwordRequired': false,
        'e2ee': false,
        'locked': false,
        'maxParticipants': 10,
        'expiresAt': '2030-01-01T00:00:00Z',
      });

      final rotated = await repository.rotateCode(testCode);

      expect(rotated.code.value, 'mnpqrstuvw');
      expect(await repository.isOwner(testCode), isFalse);
      expect(await repository.isOwner(rotated.code), isTrue);
      expect((await recents.load()).single.code, rotated.code);
    });

    test('a 403 from the server is a ForbiddenFailure', () async {
      respond = (_, _) => const FakeResponse(403, {'status': 403});

      await expectLater(
        repository.endRoom(testCode),
        throwsA(const ForbiddenFailure()),
      );
      expect(await repository.isOwner(testCode), isTrue);
    });

    test('a connection error is a NetworkFailure', () async {
      final offline = ApiRoomRepository(
        RoomApiDataSource(
          fakeDio(
            FakeHttpAdapter(
              (r) => throw DioException.connectionError(
                requestOptions: r,
                reason: 'offline',
              ),
            ),
          ),
        ),
        OwnerTokenStore(store),
        recents,
        clock,
      );

      await expectLater(
        offline.endRoom(testCode),
        throwsA(const NetworkFailure()),
      );
    });
  });
}
