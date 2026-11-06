import 'dart:convert';

enum RoomPasswordIssue { tooShort, tooLong }

abstract final class RoomPassword {
  static const minLength = 4;
  static const maxLength = 64;
  // The API also caps passwords at 72 UTF-8 bytes.
  static const maxBytes = 72;

  static RoomPasswordIssue? check(String password) {
    final characters = password.runes.length;
    if (characters < minLength) {
      return RoomPasswordIssue.tooShort;
    }
    if (characters > maxLength || utf8.encode(password).length > maxBytes) {
      return RoomPasswordIssue.tooLong;
    }
    return null;
  }
}
