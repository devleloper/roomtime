import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class ApiDataSource {
  final String baseUrl = 'http://localhost:8080/v1'; // Local API

  Future<String> fetchToken(
    String roomName,
    String participantName, {
    String? pin,
  }) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/rooms/join'),
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
      throw Exception('Failed to get token: \${response.body}');
    }
  }
}
