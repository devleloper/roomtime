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

    try {
      // Fetch server public key (this endpoint is unencrypted)
      final response = await _dio.get('/keys/public');
      if (response.statusCode == 200) {
        final key = response.data['server_public_key'] as String;
        await E2EeClient.setServerPublicKey(key);
      } else {
        throw Exception('Failed to fetch server public key for E2EE');
      }
    } catch (e, stackTrace) {
      print('🚨 REAL NETWORK ERROR (_ensureE2EEInitialized): $e\n$stackTrace');
      rethrow;
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
            "MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw\n"
            "TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh\n"
            "cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4\n"
            "WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu\n"
            "ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY\n"
            "MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc\n"
            "h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+\n"
            "0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U\n"
            "A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW\n"
            "T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH\n"
            "B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC\n"
            "B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv\n"
            "KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn\n"
            "OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn\n"
            "jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw\n"
            "qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI\n"
            "rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV\n"
            "HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq\n"
            "hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL\n"
            "ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ\n"
            "3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK\n"
            "NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5\n"
            "ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur\n"
            "TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC\n"
            "jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb/ZAJzVc\n"
            "oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq\n"
            "4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA\n"
            "mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d\n"
            "emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=\n"
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
    } on DioException catch (e, stackTrace) {
      print(
        '🚨 REAL NETWORK ERROR (fetchToken DioException): ${e.error ?? e}\n$stackTrace',
      );
      if (e.type == DioExceptionType.badCertificate) {
        throw Exception(
          'SSL certificate verification failed. '
          'Possible MITM attack detected.',
        );
      }
      throw Exception('Network error: ${e.message} (Real error: ${e.error})');
    } catch (e, stackTrace) {
      print('🚨 REAL NETWORK ERROR (fetchToken): $e\n$stackTrace');
      rethrow;
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
    } on DioException catch (e, stackTrace) {
      print(
        '🚨 REAL NETWORK ERROR (fetchRooms DioException): ${e.error ?? e}\n$stackTrace',
      );
      throw Exception('Network error: ${e.message} (Real error: ${e.error})');
    } catch (e, stackTrace) {
      print('🚨 REAL NETWORK ERROR (fetchRooms): $e\n$stackTrace');
      rethrow;
    }
  }
}

List<Map<String, dynamic>> _parseRooms(String bodyText) {
  final data = jsonDecode(bodyText);
  if (data == null) return <Map<String, dynamic>>[];
  return (data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
}
