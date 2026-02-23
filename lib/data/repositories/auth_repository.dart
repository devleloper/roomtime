import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/api_data_source.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final ApiDataSource _apiDataSource;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  AuthRepository(this._apiDataSource);

  @override
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${_apiDataSource.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'] as String;
      await _secureStorage.write(key: _tokenKey, value: token);
      return token;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Future<String> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('${_apiDataSource.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'] as String;
      await _secureStorage.write(key: _tokenKey, value: token);
      return token;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
