import 'package:flutter/foundation.dart';

@immutable
class AppConfig {
  static const _apiBaseUrlDefine = String.fromEnvironment('API_BASE_URL');

  final Uri apiBaseUrl;

  const AppConfig({required this.apiBaseUrl});

  factory AppConfig.fromEnvironment() {
    return AppConfig.resolve(
      apiBaseUrl: _apiBaseUrlDefine,
      webOrigin: kIsWeb ? Uri.base.origin : null,
    );
  }

  @visibleForTesting
  factory AppConfig.resolve({required String apiBaseUrl, String? webOrigin}) {
    var raw = apiBaseUrl.trim();
    if (raw.isEmpty) {
      // On web, fall back to the current page origin when API_BASE_URL is omitted.
      if (webOrigin == null || webOrigin.isEmpty) {
        throw StateError(
          'API_BASE_URL is not set. Run with '
          '--dart-define-from-file=config/local.json (see config/README.md).',
        );
      }
      raw = webOrigin;
    }
    return AppConfig(apiBaseUrl: _origin(raw));
  }

  String get apiV1 => '${apiBaseUrl.toString()}/v1';

  static Uri _origin(String value) {
    var raw = value;
    while (raw.endsWith('/')) {
      raw = raw.substring(0, raw.length - 1);
    }

    final uri = Uri.tryParse(raw);
    final isHttpScheme =
        uri != null && (uri.isScheme('http') || uri.isScheme('https'));
    if (!isHttpScheme || uri.host.isEmpty) {
      throw StateError('API_BASE_URL must be an http(s) origin, got "$raw".');
    }

    return uri;
  }
}
