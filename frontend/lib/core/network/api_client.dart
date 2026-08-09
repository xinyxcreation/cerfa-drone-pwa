import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/session_storage.dart';

class ApiClient {
  ApiClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (
        options,
        handler,
      ) async {
        final token =
        await SessionStorage.getAccessToken();

        if (token != null &&
          token.isNotEmpty) {
          options.headers['Authorization'] =
          'Bearer $token';
          }

          handler.next(options);
      },
    ),
  );
}
