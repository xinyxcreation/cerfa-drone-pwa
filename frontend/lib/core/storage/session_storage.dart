import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  SessionStorage._();

  static const String _accessTokenKey = 'access_token';

  static Future<void> saveAccessToken(
    String accessToken,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _accessTokenKey,
      accessToken,
    );
  }

  static Future<String?> getAccessToken() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(
      _accessTokenKey,
    );
  }

  static Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(
      _accessTokenKey,
    );
  }
}
