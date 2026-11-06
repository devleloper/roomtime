import 'package:roomtime/data/local/key_value_store.dart';
import 'package:roomtime/domain/failures/failure.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FlakyStorage implements FlutterSecureStorage {
  final values = <String, String>{};
  Exception? failure;

  Future<T> _run<T>(T Function() action) async {
    final error = failure;
    if (error != null) throw error;
    return action();
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) => _run(() => values[key]);

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) => _run(() => values[key] = value!);

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) => _run(() => values.remove(key));

  @override
  Future<Map<String, String>> readAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) => _run(() => Map.of(values));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('a transient error fails one operation as a Failure; stored data stays '
      'visible', () async {
    final storage = FlakyStorage()..values['owner'] = 'token';
    final store = SecureKeyValueStore(storage);

    storage.failure = PlatformException(
      code: 'Unexpected security result code',
      details: -25308,
    );
    await expectLater(
      store.read('owner'),
      throwsA(const UnknownFailure(code: 'storage')),
    );
    await expectLater(store.write('owner', 'other'), throwsA(isA<Failure>()));

    storage.failure = null;
    expect(await store.read('owner'), 'token');
    await store.write('owner', 'next');
    expect(storage.values['owner'], 'next', reason: 'still the platform');
  });

  test('missing keychain entitlement (-34018) falls back to memory', () async {
    final storage = FlakyStorage()
      ..failure = PlatformException(
        code: 'Unexpected security result code',
        details: SecureKeyValueStore.missingEntitlementStatus,
      );
    final store = SecureKeyValueStore(storage);

    expect(await store.read('guest'), isNull);
    storage.failure = null;
    await store.write('guest', 'g1');
    expect(await store.read('guest'), 'g1');
    expect(storage.values, isEmpty, reason: 'memory for the whole session');
  });

  test('no plugin (unsupported platform) falls back to memory', () async {
    final storage = FlakyStorage()..failure = MissingPluginException();
    final store = SecureKeyValueStore(storage);
    await store.write('k', 'v');
    expect(await store.readAll(), {'k': 'v'});
  });
}
