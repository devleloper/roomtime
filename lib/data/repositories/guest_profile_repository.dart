import 'dart:convert';
import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:roomtime/data/local/key_value_store.dart';
import 'package:roomtime/domain/entities/guest_profile.dart';
import 'package:roomtime/domain/repositories/guest_profile_repository.dart';

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

@LazySingleton(as: GuestProfileRepository)
class LocalGuestProfileRepository implements GuestProfileRepository {
  static const _key = 'guest_profile';

  final KeyValueStore _store;
  final Random _random;
  GuestProfile? _cached;

  Future<GuestProfile>? _loading;

  LocalGuestProfileRepository(this._store, {@ignoreParam Random? random})
    : _random = random ?? Random.secure();

  @override
  Future<GuestProfile> load() async {
    final cached = _cached;
    if (cached != null) {
      return cached;
    }

    // Share in-flight load so concurrent callers don't generate duplicate profiles.
    if (_loading == null) {
      _loading = _loadOrCreate();
    }

    final pending = _loading!;
    try {
      return await pending;
    } finally {
      if (identical(_loading, pending)) {
        _loading = null;
      }
    }
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

    final current = await load();
    final updated = current.copyWith(displayName: normalized);
    await _save(updated);
    return updated;
  }

  Future<GuestProfile> _loadOrCreate() async {
    final raw = await _store.read(_key);
    final stored = _decode(raw);
    if (stored != null) {
      _cached = stored;
      return stored;
    }

    final created = GuestProfile(guestId: uuidV4(_random), displayName: '');
    await _save(created);
    return created;
  }

  Future<void> _save(GuestProfile profile) async {
    _cached = profile;
    final encoded = jsonEncode(profile.toJson());
    await _store.write(_key, encoded);
  }

  GuestProfile? _decode(String? raw) {
    if (raw == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final profile = GuestProfile.fromJson(decoded);
        if (_uuidPattern.hasMatch(profile.guestId)) {
          return profile;
        }
      }
    } on Object {
      // Ignore corrupted profile JSON and regenerate.
    }
    return null;
  }
}

String uuidV4(Random random) {
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
