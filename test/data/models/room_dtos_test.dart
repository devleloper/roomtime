import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/data/models/room_dtos.dart';
import 'package:roomtime/domain/entities/room.dart';

Map<String, dynamic> lookupJson() => {
  'code': 'abcdefghjk',
  'inviteUrl': 'https://calls.example.org/r/abc-defg-hjk',
  'name': 'Family',
  'passwordRequired': false,
  'e2ee': false,
  'locked': false,
  'expiresAt': '2030-01-01T00:00:00Z',
};

Map<String, dynamic> joinJson({String livekitUrl = 'wss://media.test'}) => {
  'token': 'lk-token',
  'livekitUrl': livekitUrl,
  'identity': 'p_self',
  'role': 'host',
  'room': {
    'code': 'abcdefghjk',
    'inviteUrl': 'https://calls.example.org/r/abc-defg-hjk',
    'passwordRequired': true,
    'e2ee': false,
    'locked': false,
    'maxParticipants': 6,
    'expiresAt': '2030-01-01T00:00:00Z',
  },
};

void main() {
  group('RoomLookup (RoomSummaryDto)', () {
    test('parses the spec example', () {
      final summary = RoomSummaryDto.fromJson(lookupJson()).toDomain();
      expect(summary.expiresAt, DateTime.utc(2030));
      expect(summary.name, 'Family');
      expect(
        summary.inviteUrl,
        Uri.parse('https://calls.example.org/r/abc-defg-hjk'),
      );
    });

    for (final inviteUrl in ['/r/abc-defg-hjk', 'calls.example.org', 'x:y']) {
      test('rejects a lookup with a non-http inviteUrl "$inviteUrl"', () {
        expect(
          () => RoomSummaryDto.fromJson(
            lookupJson()..['inviteUrl'] = inviteUrl,
          ).toDomain(),
          throwsFormatException,
        );
      });
    }

    for (final field in [
      'code',
      'inviteUrl',
      'passwordRequired',
      'e2ee',
      'locked',
      'expiresAt',
    ]) {
      test('rejects a lookup without $field', () {
        expect(
          () => RoomSummaryDto.fromJson(lookupJson()..remove(field)).toDomain(),
          throwsA(anyOf(isA<FormatException>(), isA<TypeError>())),
        );
      });
    }
  });

  group('JoinResponse (RoomJoinDto)', () {
    test('parses the spec example', () {
      final join = RoomJoinDto.fromJson(
        joinJson(),
      ).toDomain(requireSecureMedia: true);
      expect(join.role, RoomRole.host);
      expect(join.room.maxParticipants, 6);
      expect(join.room.expiresAt, DateTime.utc(2030));
      expect(
        join.room.inviteUrl,
        Uri.parse('https://calls.example.org/r/abc-defg-hjk'),
      );
    });

    test('rejects a response without room', () {
      expect(
        () => RoomJoinDto.fromJson(joinJson()..remove('room')).toDomain(),
        throwsA(anyOf(isA<FormatException>(), isA<TypeError>())),
      );
    });

    for (final field in [
      'code',
      'inviteUrl',
      'passwordRequired',
      'e2ee',
      'locked',
      'maxParticipants',
      'expiresAt',
    ]) {
      test('rejects room without $field', () {
        final json = joinJson();
        (json['room'] as Map<String, dynamic>).remove(field);
        expect(
          () => RoomJoinDto.fromJson(json).toDomain(),
          throwsA(anyOf(isA<FormatException>(), isA<TypeError>())),
        );
      });
    }
  });

  group('media URL', () {
    test('release: wss accepted, ws and other schemes rejected', () {
      expect(
        mediaUrl('wss://media.test', requireSecure: true),
        'wss://media.test',
      );
      expect(
        () => mediaUrl('ws://media.test', requireSecure: true),
        throwsFormatException,
      );
      expect(
        () => mediaUrl('https://media.test', requireSecure: true),
        throwsFormatException,
      );
    });

    test('debug: ws allowed for a local backend', () {
      expect(
        mediaUrl('ws://localhost:7880', requireSecure: false),
        'ws://localhost:7880',
      );
      expect(
        () => mediaUrl('not a url', requireSecure: false),
        throwsFormatException,
      );
    });

    test('release: ws on a loopback host is allowed, '
        'not on a look-alike host', () {
      for (final url in [
        'ws://localhost:8080',
        'ws://127.0.0.1:8080',
        'ws://[::1]:8080',
      ]) {
        expect(mediaUrl(url, requireSecure: true), url);
      }
      expect(
        () => mediaUrl('ws://localhost.evil.test', requireSecure: true),
        throwsFormatException,
      );
      expect(
        RoomJoinDto.fromJson(
          joinJson(livekitUrl: 'ws://localhost:8080'),
        ).toDomain(requireSecureMedia: true).livekitUrl,
        'ws://localhost:8080',
      );
    });

    test('join with an insecure media URL fails in release mode', () {
      expect(
        () => RoomJoinDto.fromJson(
          joinJson(livekitUrl: 'ws://media.test'),
        ).toDomain(requireSecureMedia: true),
        throwsFormatException,
      );
    });
  });

  group('DTO serialization round-trips', () {
    test('CreateRoomRequestDto omits null fields and round-trips', () {
      final dto = CreateRoomRequestDto.fromParams(
        const CreateRoomParams(name: 'Family', maxParticipants: 8),
      );
      expect(dto.toJson(), {'name': 'Family', 'maxParticipants': 8});
      expect(CreateRoomRequestDto.fromJson(dto.toJson()), dto);
    });

    test('JoinRequestDto omits null password and round-trips', () {
      const dto = JoinRequestDto(displayName: 'Ann', guestId: 'g-1');
      expect(dto.toJson(), {'displayName': 'Ann', 'guestId': 'g-1'});
      expect(JoinRequestDto.fromJson(dto.toJson()), dto);
    });

    test('RotatedCodeDto parses and round-trips', () {
      final dto = RotatedCodeDto.fromJson({
        'code': 'abcdefghjk',
        'inviteUrl': 'https://calls.example.org/r/abc-defg-hjk',
      });
      expect(dto.toDomain().code.value, 'abcdefghjk');
      expect(RotatedCodeDto.fromJson(dto.toJson()), dto);
    });
  });

  test('toString hides passwords and tokens', () {
    const join = JoinRequestDto(
      displayName: 'Ann',
      guestId: 'g-1',
      password: 'hunter22',
    );
    const create = CreateRoomRequestDto(password: 'hunter22');
    final roomJoin = RoomJoinDto.fromJson(joinJson());

    expect(join.toString(), isNot(contains('hunter22')));
    expect(create.toString(), isNot(contains('hunter22')));
    expect(roomJoin.toString(), isNot(contains('lk-token')));
  });
}
