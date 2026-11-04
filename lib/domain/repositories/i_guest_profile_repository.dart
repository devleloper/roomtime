import '../entities/guest_profile.dart';

abstract interface class IGuestProfileRepository {
  /// Returns the stored profile, creating and persisting a new `guestId` on
  /// first use.
  Future<GuestProfile> load();

  /// Saves a display name (see [GuestProfile.normalizeDisplayName]); throws
  /// [ArgumentError] for an empty or too long name.
  Future<GuestProfile> updateDisplayName(String displayName);
}
