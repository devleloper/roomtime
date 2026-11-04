import 'package:roomtime/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses API_BASE_URL and strips trailing slashes', () {
    final config = AppConfig.resolve(apiBaseUrl: 'http://localhost:8080/');
    expect(config.apiV1, 'http://localhost:8080/v1');
  });

  test('falls back to the web origin when API_BASE_URL is empty', () {
    final config = AppConfig.resolve(
      apiBaseUrl: '',
      webOrigin: 'https://calls.example.com',
    );
    expect(config.apiV1, 'https://calls.example.com/v1');
  });

  test('fails fast without API_BASE_URL outside the web', () {
    expect(() => AppConfig.resolve(apiBaseUrl: ''), throwsStateError);
  });

  test('rejects non-http values', () {
    expect(
      () => AppConfig.resolve(apiBaseUrl: 'localhost:8080'),
      throwsStateError,
    );
    expect(
      () => AppConfig.resolve(apiBaseUrl: 'ftp://x.test'),
      throwsStateError,
    );
  });
}
