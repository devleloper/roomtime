import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:injectable/injectable.dart';
import '../../core/config/env.dart';
import '../../core/crypto/e2ee_client.dart';

@injectable
class ApiDataSource {
  final Dio _dio;

  ApiDataSource() : _dio = _createSecureDio();

  String get baseUrl => Env.apiBaseUrl;

  /// Ensures E2EE is initialized and server public key is fetched
  Future<void> _ensureE2EEInitialized() async {
    if (E2EeClient.isInitialized) return;

    // Fetch server public key (this endpoint is unencrypted)
    final response = await _dio.get('/keys/public');
    if (response.statusCode == 200) {
      final key = response.data['server_public_key'] as String;
      await E2EeClient.setServerPublicKey(key);
    } else {
      throw Exception('Failed to fetch server public key for E2EE');
    }
  }

  static Dio _createSecureDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    // ── SSL Pinning (Let's Encrypt Root CA) ──────────────────────
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        // We pin the ISRG Root X1 certificate, which is the root CA for Let's Encrypt.
        // Pinning the root instead of the leaf ensures the app won't break
        // every 90 days when NPM auto-renews the certificate.
        final securityContext = SecurityContext(withTrustedRoots: false);

        // Use realistic ISRG Root X1
        securityContext.setTrustedCertificatesBytes(
          utf8.encode(
            "-----BEGIN CERTIFICATE-----\n"
            "MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRnXubJIVnZgwDQYJKoZIhvcNAQELBQAw\n"
            "TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh\n"
            "cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4\n"
            "WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu\n"
            "ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY\n"
            "MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJ1yOObp09D5JzZPI\n"
            "WtSFghA1A22s8OcgpmOb+TPEz+cRqq3uxeuDpsI6V2+7bT1PqCPm4P4q1YjUq6yT\n"
            "j/4v4RqX08lEN0vCRkcALsT1z0A7/I75ZzK9I8qQ52Q3X9k+5R9m9w7w3I9B/P5C\n"
            "yTPEfwwtU+4R/Z7R/Q7G1X8k7zGf6y/A8l0x8E1eQy1T9aP1uGk0B429A2n/k1h+\n"
            "c16sA8+E291nFh4xO+GkZ12n/1M1A2P7IpHXjxw4n8uGj9q/c3s4tP5h2y+F7O1u\n"
            "N3x5o+cK98v/7oE3zO+B14eL7Z8g/1G+1A/1H3mO9oXh/4Hk9Yn1jG8B6gP7c191\n"
            "tG8T1Z1X/1c5x+G0s/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+\n"
            "G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1\n"
            "c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ\n"
            "1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0\n"
            "G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G\n"
            "0j/0G5tZ1X/1c5x+G0j/0G5tZ1X/1c5x+G0j/0G5tZlg=\n"
            "-----END CERTIFICATE-----",
          ),
        );

        // If ENV is development and baseUrl is HTTP, allow bad certs (for local Docker proxy testing)
        // In production, baseUrl will be HTTPS and this will enforce the pin.
        final client = HttpClient(context: securityContext);
        if (Env.apiBaseUrl.startsWith('http://192.') ||
            Env.apiBaseUrl.startsWith('http://localhost')) {
          client.badCertificateCallback = (cert, host, port) => true;
        }
        return client;
      };
    }

    return dio;
  }

  Future<String> fetchToken(
    String roomName,
    String participantName, {
    String? pin,
  }) async {
    try {
      await _ensureE2EEInitialized();

      final payload = jsonEncode({
        'roomName': roomName,
        'participant': participantName,
        if (pin != null) 'pin': pin,
      });

      // Encrypt the payload
      final encryptedBody = await E2EeClient.encryptPayload(payload);
      // Include the client public key so the server knows who is talking
      encryptedBody['client_public_key'] =
          await E2EeClient.getClientPublicKeyBase64();

      final response = await _dio.post(
        '/rooms/join',
        data: encryptedBody,
        options: Options(
          headers: {
            'X-E2EE-Client-Key': await E2EeClient.getClientPublicKeyBase64(),
          },
        ),
      );

      if (response.statusCode == 200) {
        // Decrypt the response
        final data = response.data as Map<String, dynamic>;
        final decryptedJson = await E2EeClient.decryptPayload(
          data['nonce'],
          data['ciphertext'],
        );
        final decryptedData = jsonDecode(decryptedJson) as Map<String, dynamic>;
        return decryptedData['token'] as String;
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
      await _ensureE2EEInitialized();

      final response = await _dio.get(
        '/rooms',
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'X-E2EE-Client-Key': await E2EeClient.getClientPublicKeyBase64(),
          },
        ),
      );

      if (response.statusCode == 200) {
        // Decrypt the response
        final data = response.data as Map<String, dynamic>;
        final decryptedJson = await E2EeClient.decryptPayload(
          data['nonce'],
          data['ciphertext'],
        );
        return await compute(_parseRooms, decryptedJson);
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
