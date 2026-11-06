import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/domain/entities/room_password.dart';

void main() {
  test('4..64 Latin characters are valid', () {
    expect(RoomPassword.check('abcd'), isNull);
    expect(RoomPassword.check('a' * 64), isNull);
    expect(RoomPassword.check('abc'), RoomPasswordIssue.tooShort);
    expect(RoomPassword.check('a' * 65), RoomPasswordIssue.tooLong);
  });

  test('Cyrillic is limited by the 72-byte cap', () {
    expect(RoomPassword.check('я' * 36), isNull);
    expect(RoomPassword.check('я' * 37), RoomPasswordIssue.tooLong);
    expect(RoomPassword.check('я' * 40), RoomPasswordIssue.tooLong);
  });

  test('length counts code points, not UTF-16 units', () {
    expect(RoomPassword.check('😀😀😀'), RoomPasswordIssue.tooShort);
    expect(RoomPassword.check('😀😀😀😀'), isNull);
    expect(RoomPassword.check('😀' * 18), isNull);
    expect(RoomPassword.check('😀' * 19), RoomPasswordIssue.tooLong);
  });

  test('taken verbatim: spaces count', () {
    expect(RoomPassword.check('  a '), isNull);
  });
}
