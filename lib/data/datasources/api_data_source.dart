import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../../core/config/env.dart';

@injectable
class ApiDataSource {
  final String baseUrl = Env.apiBaseUrl;

  Future<String> fetchToken(
    String roomName,
    String participantName, {
    String? pin,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomName': roomName,
        'participant': participantName,
        'pin': pin,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to get token: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRooms() async {
    final response = await http.get(Uri.parse('$baseUrl/rooms'));

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data == null) return [];

      return (data as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to fetch rooms: ${response.body}');
    }
  }
}
