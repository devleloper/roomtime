import 'package:equatable/equatable.dart';

/// A room invitation code (room API v1): 10 letters from [alphabet], shown as
/// `abc-defg-hjk`. Instances are always normalized and valid.
final class RoomCode extends Equatable {
  const RoomCode._(this.value);

  /// 23 lowercase letters without `i`, `l` and `o`.
  static const alphabet = 'abcdefghjkmnpqrstuvwxyz';
  static const length = 10;

  static final _invitePath = RegExp(r'(?:^|/)r/([^/?#]+)');
  static final _separators = RegExp(r'[\s-]');

  /// The normalized code: 10 lowercase letters, no separators.
  final String value;

  /// Parses a bare code (any case, spaces and dashes allowed) or a full invite
  /// link (`https://host/r/<code>`, `/r/<code>`, with optional query or
  /// fragment). Returns `null` when the input is not a valid code.
  static RoomCode? tryParse(String input) {
    var candidate = input.trim();
    final link = _invitePath.firstMatch(candidate);
    if (link != null) {
      try {
        candidate = Uri.decodeComponent(link.group(1)!);
      } on ArgumentError {
        return null; // Broken percent-escape, e.g. a link cut by a messenger.
      } on FormatException {
        return null; // Valid escape, invalid UTF-8 (`%FF`).
      }
    }
    final normalized = candidate.toLowerCase().replaceAll(_separators, '');
    if (normalized.length != length) return null;
    for (final unit in normalized.split('')) {
      if (!alphabet.contains(unit)) return null;
    }
    return RoomCode._(normalized);
  }

  /// Display form `abc-defg-hjk`.
  String get display =>
      '${value.substring(0, 3)}-${value.substring(3, 7)}-${value.substring(7)}';

  @override
  List<Object?> get props => [value];

  @override
  String toString() => display;
}
