import 'package:roomtime/domain/entities/room_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoomCode.tryParse', () {
    test('accepts a bare normalized code', () {
      expect(RoomCode.tryParse('abcdefghjk')?.value, 'abcdefghjk');
    });

    test('normalizes case, spaces and dashes', () {
      for (final input in [
        'ABC-DEFG-HJK',
        '  abc defg hjk ',
        'abc-defg-hjk',
        'Abc - Defg - Hjk',
        'ab\tcdefghjk\n',
      ]) {
        expect(RoomCode.tryParse(input)?.value, 'abcdefghjk', reason: input);
      }
    });

    test('accepts full invite links', () {
      for (final input in [
        'https://calls.example.com/r/abcdefghjk',
        'https://calls.example.com/r/abc-defg-hjk',
        'http://localhost:8080/r/ABC-DEFG-HJK?ref=share',
        'https://calls.example.com/r/abcdefghjk#e2ee-key',
        'https://calls.example.com/r/abcdefghjk/',
        'calls.example.com/r/abcdefghjk',
        '/r/abcdefghjk',
        'r/abcdefghjk',
      ]) {
        expect(RoomCode.tryParse(input)?.value, 'abcdefghjk', reason: input);
      }
    });

    test('rejects letters outside the alphabet (i, l, o) and digits', () {
      for (final input in [
        'abcdefghji',
        'abcdefghjl',
        'abcdefghjo',
        'abcdefghj1',
        'abcdefghj_',
        'abcdefghjé',
      ]) {
        expect(RoomCode.tryParse(input), isNull, reason: input);
      }
    });

    test('rejects wrong lengths and empty input', () {
      for (final input in [
        '',
        '   ',
        'abcdefghj',
        'abcdefghjkm',
        'https://calls.example.com/r/',
        'https://calls.example.com/rooms',
      ]) {
        expect(RoomCode.tryParse(input), isNull, reason: input);
      }
    });

    test('accepts every letter of the alphabet', () {
      const alphabet = RoomCode.alphabet;
      expect(alphabet.length, 23);
      expect(RoomCode.tryParse(alphabet.substring(0, 10)), isNotNull);
      expect(RoomCode.tryParse(alphabet.substring(13, 23)), isNotNull);
    });
  });

  test('display formats as abc-defg-hjk', () {
    expect(RoomCode.tryParse('abcdefghjk')!.display, 'abc-defg-hjk');
  });

  test('codes compare by value', () {
    expect(
      RoomCode.tryParse('ABC-DEFG-HJK'),
      RoomCode.tryParse('https://x.test/r/abcdefghjk'),
    );
  });

  // CR-C5: a link cut inside a percent-escape is "not a code", not a crash.
  test('broken percent-escapes in a link return null', () {
    expect(
      RoomCode.tryParse('https://calls.example.com/r/abc-defg-hjk%'),
      isNull,
    );
    expect(RoomCode.tryParse('https://calls.example.com/r/%zz'), isNull);
    expect(RoomCode.tryParse('/r/%'), isNull);
  });

  // CR3-8: a well-formed escape of invalid UTF-8 throws FormatException.
  test('percent-escapes of invalid UTF-8 return null', () {
    expect(RoomCode.tryParse('https://host/r/%FF'), isNull);
    expect(RoomCode.tryParse('/r/abc%C3'), isNull);
  });
}
