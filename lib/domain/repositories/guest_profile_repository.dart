import 'package:roomtime/domain/entities/guest_profile.dart';

abstract interface class GuestProfileRepository {
  Future<GuestProfile> load();

  Future<GuestProfile> updateDisplayName(String displayName);
}
