import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_code.freezed.dart';

@freezed
abstract class RoomCode with _$RoomCode {
  // Excludes i, l, o (visual ambiguity); matches the API RoomCode pattern.
  static const alphabet = 'abcdefghjkmnpqrstuvwxyz';
  static const length = 10;

  static final _invitePath = RegExp(r'(?:^|/)r/([^/?#]+)');
  static final _separators = RegExp(r'[\s-]');

  const RoomCode._();

  const factory RoomCode._internal(String value) = _RoomCode;

  String get display {
    return '${value.substring(0, 3)}-${value.substring(3, 7)}-${value.substring(7)}';
  }

  static RoomCode? tryParse(String input) {
    var candidate = input.trim();
    final link = _invitePath.firstMatch(candidate);
    if (link != null) {
      try {
        candidate = Uri.decodeComponent(link.group(1)!);
      } on ArgumentError {
        return null;
      } on FormatException {
        return null;
      }
    }

    final normalized = candidate.toLowerCase().replaceAll(_separators, '');
    if (normalized.length != length) {
      return null;
    }

    for (final unit in normalized.split('')) {
      if (!alphabet.contains(unit)) {
        return null;
      }
    }

    return RoomCode._internal(normalized);
  }

  @override
  String toString() => display;
}

class RoomCodeConverter implements JsonConverter<RoomCode, String> {
  const RoomCodeConverter();

  @override
  RoomCode fromJson(String json) {
    final code = RoomCode.tryParse(json);
    if (code != null) {
      return code;
    }
    throw FormatException('Invalid room code', json);
  }

  @override
  String toJson(RoomCode object) => object.value;
}
