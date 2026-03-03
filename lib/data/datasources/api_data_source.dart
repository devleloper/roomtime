import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/config/env.dart';

@injectable
class ApiDataSource {
  final Dio _dio;

  ApiDataSource() : _dio = _createSecureDio();

  String get baseUrl => Env.apiBaseUrl;

  static Dio _createSecureDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    // ── SSL Pinning (native platforms only) ──────────────────
    // DISABLED for development (self-signed certs on 192.168.x.x)
    // TODO: Enable for production by setting the real certificate fingerprint
    //
    // if (!kIsWeb) {
    //   (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    //     final client = HttpClient();
    //     client.badCertificateCallback = (cert, host, port) {
    //       // Pin the SHA-256 fingerprint of your server's leaf certificate.
    //       // Get it with:
    //       //   openssl s_client -connect your-domain.com:443 | \
    //       //   openssl x509 -fingerprint -sha256 -noout
    //       const pinnedFingerprint =
    //           'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:'
    //           'XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX';
    //       final serverFingerprint = cert.sha256Fingerprint;
    //       return serverFingerprint == pinnedFingerprint;
    //     };
    //     return client;
    //   };
    // }

    return dio;
  }

  Future<String> fetchToken(
    String roomName,
    String participantName, {
    String? pin,
  }) async {
    try {
      final response = await _dio.post(
        '/rooms/join',
        data: {
          'roomName': roomName,
          'participant': participantName,
          if (pin != null) 'pin': pin,
        },
      );

      if (response.statusCode == 200) {
        return response.data['token'] as String;
      } else {
        throw Exception('Failed to get token: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badCertificate) {
        throw Exception(
          'SSL certificate verification failed. '
          'Possible MITM attack detected.',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRooms() async {
    try {
      final response = await _dio.get(
        '/rooms',
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode == 200) {
        final bodyText = response.data?.toString() ?? '[]';
        return await compute(_parseRooms, bodyText);
      } else {
        throw Exception('Failed to fetch rooms: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

List<Map<String, dynamic>> _parseRooms(String bodyText) {
  final data = jsonDecode(bodyText);
  if (data == null) return <Map<String, dynamic>>[];
  return (data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
}
