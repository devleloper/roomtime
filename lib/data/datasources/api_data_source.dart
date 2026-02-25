import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/config/env.dart';

@injectable
class ApiDataSource {
  final Dio _dio;

  ApiDataSource() : _dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));

  String get baseUrl => Env.apiBaseUrl;

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
          'pin': pin,
        },
      );

      if (response.statusCode == 200) {
        return response.data['token'] as String;
      } else {
        throw Exception('Failed to get token: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRooms() async {
    try {
      // Fetch raw string to prevent Dio from parsing JSON on main thread
      final response = await _dio.get(
        '/rooms',
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode == 200) {
        final bodyText = response.data?.toString() ?? '[]';
        // Use compute to offload to an isolate on native platforms,
        // and safely fallback to the main thread on Flutter Web.
        return await compute(_parseRooms, bodyText);
      } else {
        throw Exception('Failed to fetch rooms: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

// Top-level function for compute
List<Map<String, dynamic>> _parseRooms(String bodyText) {
  final data = jsonDecode(bodyText);
  if (data == null) return <Map<String, dynamic>>[];
  return (data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
}
