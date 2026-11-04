import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/domain/entities/room.dart';

// A6-04: the same rule as openapi CreateRoomRequest.password and the server's
// room.ValidatePassword: 4..64 code points and at most 72 bytes of UTF-8.
void main() {
  test('4..64 Latin characters are valid', () {
    expect(RoomPassword.check('abcd'), isNull);
    expect(RoomPassword.check('a' * 64), isNull);
    expect(RoomPassword.check('abc'), RoomPasswordIssue.tooShort);
    expect(RoomPassword.check('a' * 65), RoomPasswordIssue.tooLong);
  });

  test('Cyrillic is limited by the 72-byte cap', () {
    expect(RoomPassword.check('я' * 36), isNull); // 72 bytes
    expect(RoomPassword.check('я' * 37), RoomPasswordIssue.tooLong);
    expect(RoomPassword.check('я' * 40), RoomPasswordIssue.tooLong);
  });

  test('length counts code points, not UTF-16 units', () {
    // 4 emoji = 8 UTF-16 units, 4 runes, 16 bytes: valid like on the server.
    expect(RoomPassword.check('😀😀😀'), RoomPasswordIssue.tooShort);
    expect(RoomPassword.check('😀😀😀😀'), isNull);
    // 18 emoji = 72 bytes; 19 = 76 bytes.
    expect(RoomPassword.check('😀' * 18), isNull);
    expect(RoomPassword.check('😀' * 19), RoomPasswordIssue.tooLong);
  });

  test('taken verbatim: spaces count', () {
    expect(RoomPassword.check('  a '), isNull);
  });
}
