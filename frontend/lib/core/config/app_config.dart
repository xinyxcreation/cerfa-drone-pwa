class AppConfig {
  AppConfig._();

  static const String appName = 'CERFA DRONE';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000',
  );
}
