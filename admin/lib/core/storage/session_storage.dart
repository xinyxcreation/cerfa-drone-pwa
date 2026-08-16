import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {

  static const String tokenKey =
      'admin_access_token';

  static const String roleKey =
      'admin_role';

  Future<void> save(
    String token,
    String role,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      tokenKey,
      token,
    );

    await prefs.setString(
      roleKey,
      role,
    );
  }

  Future<String?> getToken() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      tokenKey,
    );
  }

  Future<String?> getRole() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      roleKey,
    );
  }

  Future<void> clear() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(tokenKey);
    await prefs.remove(roleKey);
  }

}
