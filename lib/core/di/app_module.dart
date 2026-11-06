import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:roomtime/core/config/app_config.dart';

@module
abstract class AppModule {
  @singleton
  AppConfig get config => AppConfig.fromEnvironment();

  @lazySingleton
  Dio dio(AppConfig config) {
    return Dio(
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
  }

  @lazySingleton
  FlutterSecureStorage get secureStorage {
    // Keep owner tokens local to this device and accessible even if the screen locks mid-call.
    return const FlutterSecureStorage(
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
      mOptions: MacOsOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }
}
