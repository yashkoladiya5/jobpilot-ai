import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';
import 'package:jobpilot_ai/core/network/dio_client.dart';

@lazySingleton
class AuthRemoteDataSource {
  final DioClient _dioClient;
  AuthRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dioClient.post(ApiConstants.login, data: {
        'email': email.trim().toLowerCase(),
        'password': password,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      // Allow custom interceptors to pass their specific exceptions up
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    try {
      final response = await _dioClient.post(ApiConstants.register, data: {
        'email': email.trim().toLowerCase(),
        'password': password,
        'name': name.trim(),
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dioClient.get(ApiConstants.me);
    return response.data as Map<String, dynamic>;
  }
}
