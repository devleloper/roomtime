import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../domain/failures/failure.dart';

/// Small persistent string store used by the local data sources.
abstract interface class KeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<Map<String, String>> readAll();
}

/// [KeyValueStore] over the platform keychain/keystore.
///
/// Only a permanent "no keychain here" error switches it to memory for the
/// session: the missing-entitlement status `-34018` (a macOS build without
/// `keychain-access-groups`, i.e. unsigned Debug) or a missing plugin. Every
/// other error (e.g. a locked device) fails that one operation with
/// `UnknownFailure(code: 'storage')` and the next call tries the platform
/// again, so stored owner tokens are never hidden by a transient error,
/// and callers that handle a [Failure] handle this too.
@LazySingleton(as: KeyValueStore)
class SecureKeyValueStore implements KeyValueStore {
  SecureKeyValueStore(this._storage);

  /// `errSecMissingEntitlement`.
  static const missingEntitlementStatus = -34018;

  final FlutterSecureStorage _storage;
  Map<String, String>? _memoryFallback;

  static const storageFailure = UnknownFailure(code: 'storage');

  static bool isPermanentlyUnavailable(Object error) =>
      error is MissingPluginException ||
      (error is PlatformException &&
          (error.details == missingEntitlementStatus ||
              error.code == '$missingEntitlementStatus'));

  Future<T> _guard<T>(
    Future<T> Function() platform,
    T Function(Map<String, String> memory) memory,
  ) async {
    final fallback = _memoryFallback;
    if (fallback != null) return memory(fallback);
    try {
      return await platform();
    } on Exception catch (error) {
      if (!isPermanentlyUnavailable(error)) {
        // Values never reach the log; the platform error carries none.
        developer.log(
          'Secure storage operation failed: $error',
          name: 'KeyValueStore',
        );
        throw storageFailure;
      }
      developer.log(
        'Secure storage has no keychain access (unsigned build?); data is '
        'kept in memory for this session',
        name: 'KeyValueStore',
      );
      return memory(_memoryFallback = <String, String>{});
    }
  }

  @override
  Future<String?> read(String key) =>
      _guard(() => _storage.read(key: key), (m) => m[key]);

  @override
  Future<void> write(String key, String value) => _guard(
    () => _storage.write(key: key, value: value),
    (m) => m[key] = value,
  );

  @override
  Future<void> delete(String key) =>
      _guard(() => _storage.delete(key: key), (m) => m.remove(key));

  @override
  Future<Map<String, String>> readAll() =>
      _guard(_storage.readAll, (m) => Map.of(m));
}
