import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/session_storage.dart';
import '../models/login_response.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  const AuthService();

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response =
      await ApiClient.instance.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final data =
      response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw AuthException(
          data['message'] as String? ??
          'Échec de la connexion.',
        );
      }

      final result =
      LoginResponse.fromJson(data);

      await SessionStorage.saveAccessToken(
        result.accessToken,
      );

      return result;

    } on DioException catch (error) {
      final responseData =
      error.response?.data;

      if (responseData is Map<String, dynamic>) {
        throw AuthException(
          responseData['message'] as String? ??
          'Impossible de contacter le serveur.',
        );
      }

      throw const AuthException(
        'Impossible de contacter le serveur.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(
        'Une erreur inattendue est survenue.',
      );
    }
  }

  Future<void> logout() async {
    await SessionStorage.clear();
  }

  Future<bool> hasSession() async {
    final token =
    await SessionStorage.getAccessToken();

    return token != null &&
    token.isNotEmpty;
  }
}
