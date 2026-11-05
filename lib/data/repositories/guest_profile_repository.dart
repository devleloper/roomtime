import 'dart:convert';
import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../domain/entities/guest_profile.dart';
import '../../domain/repositories/i_guest_profile_repository.dart';
import '../datasources/key_value_store.dart';

@LazySingleton(as: IGuestProfileRepository)
class GuestProfileRepository implements IGuestProfileRepository {
  GuestProfileRepository(this._store, {@ignoreParam Random? random})
    : _random = random ?? Random.secure();

  static const _key = 'guest_profile';

  final KeyValueStore _store;
  final Random _random;
  GuestProfile? _cached;

  /// The first load in flight; concurrent callers share it so only one
  /// guestId is ever created.
  Future<GuestProfile>? _loading;

  @override
  Future<GuestProfile> load() async {
    final cached = _cached;
    if (cached != null) return cached;
    final pending = _loading ??= _loadOrCreate();
    try {
      return await pending;
    } finally {
      if (identical(_loading, pending)) _loading = null;
    }
  }

  Future<GuestProfile> _loadOrCreate() async {
    final stored = _decode(await _store.read(_key));
    if (stored != null) return _cached = stored;
    final created = GuestProfile(guestId: uuidV4(_random), displayName: '');
    await _save(created);
    return created;
  }

  @override
  Future<GuestProfile> updateDisplayName(String displayName) async {
    final normalized = GuestProfile.normalizeDisplayName(displayName);
    if (normalized == null) {
      throw ArgumentError.value(
        displayName,
        'displayName',
        'Must be 1-32 characters',
      );
    }
    final updated = (await load()).copyWith(displayName: normalized);
    await _save(updated);
    return updated;
  }

  Future<void> _save(GuestProfile profile) async {
    _cached = profile;
    await _store.write(
      _key,
      jsonEncode({
        'guestId': profile.guestId,
        'displayName': profile.displayName,
      }),
    );
  }

  GuestProfile? _decode(String? raw) {
    if (raw == null) return null;
    try {
      if (jsonDecode(raw) case {
        'guestId': String guestId,
        'displayName': String displayName,
      } when _uuidPattern.hasMatch(guestId)) {
        return GuestProfile(guestId: guestId, displayName: displayName);
      }
    } on FormatException {
      // Corrupt entry: a new guest identity is created.
    }
    return null;
  }
}

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

/// RFC 9562 version 4 UUID from [random] (use `Random.secure()`).
String uuidV4(Random random) {
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
