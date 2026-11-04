import 'package:equatable/equatable.dart';

/// Local guest identity. [guestId] is a random UUID created once per install;
/// it is sent only in join requests and never shown.
final class GuestProfile extends Equatable {
  const GuestProfile({required this.guestId, required this.displayName});

  static const maxDisplayNameLength = 32;

  /// Used until the user picks a name (the lobby asks for one).
  static const defaultDisplayName = 'Guest';

  final String guestId;

  /// Empty until the user sets a name.
  final String displayName;

  /// [displayName] or [defaultDisplayName], ready for a join request.
  String get effectiveDisplayName =>
      displayName.isEmpty ? defaultDisplayName : displayName;

  /// Trims [input]; returns it when 1..[maxDisplayNameLength] characters long,
  /// otherwise `null`.
  static String? normalizeDisplayName(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty || trimmed.runes.length > maxDisplayNameLength) {
      return null;
    }
    return trimmed;
  }

  GuestProfile copyWith({String? displayName}) => GuestProfile(
    guestId: guestId,
    displayName: displayName ?? this.displayName,
  );

  @override
  List<Object?> get props => [guestId, displayName];
}
