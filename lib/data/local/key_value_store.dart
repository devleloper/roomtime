import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/utils/dev_log.dart';
import 'package:roomtime/domain/failures/failure.dart';

abstract interface class KeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<Map<String, String>> readAll();
}

@LazySingleton(as: KeyValueStore)
class SecureKeyValueStore implements KeyValueStore {
  // macOS/iOS errSecMissingEntitlement (-34018) on unsigned builds.
  static const missingEntitlementStatus = -34018;
  static const storageFailure = UnknownFailure(code: 'storage');

  final FlutterSecureStorage _storage;
  Map<String, String>? _memoryFallback;

  SecureKeyValueStore(this._storage);

  static bool isPermanentlyUnavailable(Object error) {
    if (error is MissingPluginException) {
      return true;
    }
    if (error is PlatformException) {
      return error.details == missingEntitlementStatus ||
          error.code == '$missingEntitlementStatus';
    }
    return false;
  }

  @override
  Future<String?> read(String key) {
    return _guard(() => _storage.read(key: key), (memory) => memory[key]);
  }

  @override
  Future<void> write(String key, String value) {
    return _guard(() => _storage.write(key: key, value: value), (memory) {
      memory[key] = value;
    });
  }

  @override
  Future<void> delete(String key) {
    return _guard(() => _storage.delete(key: key), (memory) {
      memory.remove(key);
    });
  }

  @override
  Future<Map<String, String>> readAll() {
    return _guard(_storage.readAll, (memory) => Map.of(memory));
  }

  Future<T> _guard<T>(
    Future<T> Function() platform,
    T Function(Map<String, String> memory) memory,
  ) async {
    final fallback = _memoryFallback;
    if (fallback != null) {
      return memory(fallback);
    }

    try {
      return await platform();
    } on Exception catch (error) {
      if (!isPermanentlyUnavailable(error)) {
        devLog(
          'Secure storage operation failed: $error',
          name: 'KeyValueStore',
        );
        throw storageFailure;
      }

      devLog(
        'Secure storage has no keychain access (unsigned build?); data is '
        'kept in memory for this session',
        name: 'KeyValueStore',
      );
      final newFallback = <String, String>{};
      _memoryFallback = newFallback;
      return memory(newFallback);
    }
  }
}
