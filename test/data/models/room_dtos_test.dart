import 'package:roomtime/data/models/room_dtos.dart';
import 'package:roomtime/domain/entities/room.dart';
import 'package:flutter_test/flutter_test.dart';

// required fields follow docs/api/openapi.yaml exactly.
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
  group('RoomLookup', () {
    test('parses the spec example', () {
      final summary = roomSummaryFromJson(lookupJson());
      expect(summary.expiresAt, DateTime.utc(2030));
      expect(summary.name, 'Family');
      // A3-02: the server's link is used as is, never rebuilt locally.
      expect(
        summary.inviteUrl,
        Uri.parse('https://calls.example.org/r/abc-defg-hjk'),
      );
    });

    for (final inviteUrl in ['/r/abc-defg-hjk', 'calls.example.org', 'x:y']) {
      test('rejects a lookup with a non-http inviteUrl "$inviteUrl"', () {
        expect(
          () => roomSummaryFromJson(lookupJson()..['inviteUrl'] = inviteUrl),
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
          () => roomSummaryFromJson(lookupJson()..remove(field)),
          throwsFormatException,
        );
      });
    }
  });

  group('JoinResponse', () {
    test('parses the spec example', () {
      final join = roomJoinFromJson(joinJson(), requireSecureMedia: true);
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
        () => roomJoinFromJson(joinJson()..remove('room')),
        throwsFormatException,
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
        expect(() => roomJoinFromJson(json), throwsFormatException);
      });
    }
  });

  // release builds accept only wss:// media URLs.
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
        roomJoinFromJson(
          joinJson(livekitUrl: 'ws://localhost:8080'),
          requireSecureMedia: true,
        ).livekitUrl,
        'ws://localhost:8080',
      );
    });

    test('join with an insecure media URL fails in release mode', () {
      expect(
        () => roomJoinFromJson(
          joinJson(livekitUrl: 'ws://media.test'),
          requireSecureMedia: true,
        ),
        throwsFormatException,
      );
    });
  });
}
