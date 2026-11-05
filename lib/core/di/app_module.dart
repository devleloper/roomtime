import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';

/// Third-party and configuration bindings for the composition root.
@module
abstract class AppModule {
  @singleton
  AppConfig get config => AppConfig.fromEnvironment();

  /// The single HTTP client of the app. TLS uses the platform trust store.
  @lazySingleton
  Dio dio(AppConfig config) => Dio(
    BaseOptions(
      baseUrl: config.apiV1,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json, application/problem+json'},
    ),
  );

  /// Keychain items stay on this device (no backup or device transfer) and
  /// are readable after the first unlock, so a call that ends while the
  /// screen is locked can still read owner tokens.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}
