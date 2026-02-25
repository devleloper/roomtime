import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/api_data_source.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final ApiDataSource _apiDataSource;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final Dio _dio;
  static const _tokenKey = 'jwt_token';

  AuthRepository(this._apiDataSource) {
    _dio = Dio(BaseOptions(baseUrl: _apiDataSource.baseUrl));
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        await _secureStorage.write(key: _tokenKey, value: token);
        return token;
      } else {
        throw Exception('Failed to login: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network error during login: ${e.message}');
    }
  }

  @override
  Future<String> register(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'] as String;
        await _secureStorage.write(key: _tokenKey, value: token);
        return token;
      } else {
        throw Exception('Failed to register: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Network error during registration: ${e.message}');
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
