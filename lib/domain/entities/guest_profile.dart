import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_profile.freezed.dart';
part 'guest_profile.g.dart';

@freezed
abstract class GuestProfile with _$GuestProfile {
  static const maxDisplayNameLength = 32;
  static const defaultDisplayName = 'Guest';

  const GuestProfile._();

  const factory GuestProfile({
    required String guestId,
    required String displayName,
  }) = _GuestProfile;

  factory GuestProfile.fromJson(Map<String, dynamic> json) =>
      _$GuestProfileFromJson(json);

  String get effectiveDisplayName {
    if (displayName.isEmpty) {
      return defaultDisplayName;
    }
    return displayName;
  }

  static String? normalizeDisplayName(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty || trimmed.runes.length > maxDisplayNameLength) {
      return null;
    }
    return trimmed;
  }
}
