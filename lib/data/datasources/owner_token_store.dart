import 'dart:convert';

import 'package:injectable/injectable.dart';

import 'key_value_store.dart';

/// Owner token of one room, as stored on this device.
class OwnerTokenRecord {
  const OwnerTokenRecord({
    required this.roomId,
    required this.code,
    required this.token,
  });

  final String roomId;

  /// Current invitation code; owner endpoints are addressed by code.
  final String code;
  final String token;
}

/// Owner tokens in secure storage, one entry per roomId.
@lazySingleton
class OwnerTokenStore {
  OwnerTokenStore(this._store);

  static const _prefix = 'owner_token.';

  final KeyValueStore _store;

  Future<void> save(OwnerTokenRecord record) => _store.write(
    '$_prefix${record.roomId}',
    jsonEncode({'code': record.code, 'token': record.token}),
  );

  Future<OwnerTokenRecord?> findByCode(String code) async {
    final entries = await _store.readAll();
    for (final MapEntry(:key, :value) in entries.entries) {
      if (!key.startsWith(_prefix)) continue;
      final record = _decode(key.substring(_prefix.length), value);
      if (record != null && record.code == code) return record;
    }
    return null;
  }

  Future<void> delete(String roomId) => _store.delete('$_prefix$roomId');

  OwnerTokenRecord? _decode(String roomId, String raw) {
    try {
      final json = jsonDecode(raw);
      if (json case {'code': String code, 'token': String token}) {
        return OwnerTokenRecord(roomId: roomId, code: code, token: token);
      }
    } on FormatException {
      // A corrupt entry is ignored; the owner loses host rights for it.
    }
    return null;
  }
}
