import 'package:flutter/foundation.dart';

/// Build-time configuration, read once from `--dart-define(-from-file)`.
///
/// Values are public (URLs only); secrets never go here because everything
/// passed with `--dart-define` is compiled into the binary. Invite links are
/// not configured here: the server returns them (`inviteUrl`, A3-02).
@immutable
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  /// API origin without the `/v1` prefix, e.g. `http://localhost:8080`.
  final Uri apiBaseUrl;

  static const _apiBaseUrlDefine = String.fromEnvironment('API_BASE_URL');

  /// Base URL for the versioned API: `$apiBaseUrl/v1`.
  String get apiV1 => '${apiBaseUrl.toString()}/v1';

  factory AppConfig.fromEnvironment() => AppConfig.resolve(
    apiBaseUrl: _apiBaseUrlDefine,
    webOrigin: kIsWeb ? Uri.base.origin : null,
  );

  /// Resolves [apiBaseUrl]; an empty value falls back to [webOrigin] (the
  /// same-origin edge on web) and fails fast everywhere else.
  @visibleForTesting
  factory AppConfig.resolve({required String apiBaseUrl, String? webOrigin}) {
    var raw = apiBaseUrl.trim();
    if (raw.isEmpty) {
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

  static Uri _origin(String value) {
    var raw = value;
    while (raw.endsWith('/')) {
      raw = raw.substring(0, raw.length - 1);
    }
    final uri = Uri.tryParse(raw);
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        uri.host.isEmpty) {
      throw StateError('API_BASE_URL must be an http(s) origin, got "$raw".');
    }
    return uri;
  }
}
