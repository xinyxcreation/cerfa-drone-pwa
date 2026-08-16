import '../config/api_config.dart';
import '../network/api_client.dart';
import '../storage/session_storage.dart';

class AdminAuthService {

  final SessionStorage storage =
      SessionStorage();

  String? token;

  String? role;

  bool get isAuthenticated =>
      token != null &&
      role != null;

  bool get isAdmin =>
      role == 'ADMIN';

  bool get isModerator =>
      role == 'MODERATOR';

  Future<void> restoreSession() async {

    token =
        await storage.getToken();

    role =
        await storage.getRole();

    if (token == null ||
        role == null) {

      token = null;
      role = null;

      return;
    }

    try {

      final api =
          ApiClient(token: token);

      final response =
          await api.get(
        '${ApiConfig.baseUrl}/admin/auth/me',
      );

      if (
          response.data['success'] != true
      ) {

        await logout();
      }

    } catch (_) {

      await logout();

    }

  }

  Future<String?> login(
    String email,
    String password,
  ) async {

    try {

      final api =
          ApiClient();

      final response =
          await api.post(
        '${ApiConfig.baseUrl}/admin/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data =
          response.data;

      if (data['success'] != true) {

        return data['message'] ??
            'Connexion impossible.';
      }

      token =
          data['access_token'];

      role =
          data['platform']['role'];

      await storage.save(
        token!,
        role!,
      );

      return null;

    } catch (error) {

      return 'Impossible de contacter le serveur.';

    }

  }

  Future<void> logout() async {

    token = null;
    role = null;

    await storage.clear();

  }

}
