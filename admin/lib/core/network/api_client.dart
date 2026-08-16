import 'package:dio/dio.dart';

class ApiClient {

  final Dio dio;

  ApiClient({
    String? token,
  }) : dio = Dio(
          BaseOptions(
            headers: {
              'Content-Type':
                  'application/json',
              if (token != null)
                'Authorization':
                    'Bearer $token',
            },
          ),
        );

  Future<Response<dynamic>> get(
    String url,
  ) {
    return dio.get(url);
  }

  Future<Response<dynamic>> post(
    String url, {
    Object? data,
  }) {
    return dio.post(
      url,
      data: data,
    );
  }

  Future<Response<dynamic>> put(
    String url, {
    Object? data,
  }) {
    return dio.put(
      url,
      data: data,
    );
  }

}
