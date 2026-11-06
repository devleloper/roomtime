import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/data/local/key_value_store.dart';

part 'owner_token_store.freezed.dart';
part 'owner_token_store.g.dart';

@freezed
abstract class OwnerTokenRecord with _$OwnerTokenRecord {
  const OwnerTokenRecord._();

  const factory OwnerTokenRecord({
    required String roomId,
    required String code,
    required String token,
  }) = _OwnerTokenRecord;

  factory OwnerTokenRecord.fromJson(Map<String, dynamic> json) =>
      _$OwnerTokenRecordFromJson(json);

  @override
  String toString() => 'OwnerTokenRecord(roomId: $roomId, code: $code)';
}

@lazySingleton
class OwnerTokenStore {
  static const _prefix = 'owner_token.';

  final KeyValueStore _store;

  OwnerTokenStore(this._store);

  Future<void> save(OwnerTokenRecord record) {
    final key = '$_prefix${record.roomId}';
    final payload = jsonEncode(record.toJson());
    return _store.write(key, payload);
  }

  Future<OwnerTokenRecord?> findByCode(String code) async {
    final entries = await _store.readAll();
    for (final MapEntry(:key, :value) in entries.entries) {
      if (!key.startsWith(_prefix)) {
        continue;
      }

      final roomId = key.substring(_prefix.length);
      final record = _decode(roomId, value);
      if (record != null && record.code == code) {
        return record;
      }
    }
    return null;
  }

  Future<void> delete(String roomId) {
    return _store.delete('$_prefix$roomId');
  }

  OwnerTokenRecord? _decode(String roomId, String raw) {
    try {
      final json = jsonDecode(raw);
      if (json is Map<String, dynamic>) {
        return OwnerTokenRecord.fromJson({...json, 'roomId': roomId});
      }
    } on Object {
      // Ignore corrupted entries.
    }
    return null;
  }
}
