import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../models/company.dart';

class CompanyService {
  CompanyService._();

  static Future<Company> getCompany() async {
    try {
      final response =
      await ApiClient.instance.get(
        '/auth/company',
      );

      final data =
      Map<String, dynamic>.from(
        response.data as Map,
      );

      if (data['success'] != true) {
        throw Exception(
          data['message'] ??
          'Impossible de charger l’entreprise.',
        );
      }

      return Company.fromJson(
        Map<String, dynamic>.from(
          data['company'] as Map,
        ),
      );
    } on DioException catch (error) {
      throw Exception(
        _messageFromError(
          error,
          'Impossible de charger l’entreprise.',
        ),
      );
    }
  }

  static Future<Company> updateCompany(
    Company company,
  ) async {
    try {
      final response =
          await ApiClient.instance.put(
        '/auth/company',
        data: company.toUpdateJson(),
      );

      final data =
          Map<String, dynamic>.from(
        response.data as Map,
      );

      if (data['success'] != true) {
        throw Exception(
          data['message'] ??
              'Impossible de modifier l’entreprise.',
        );
      }

      return Company.fromJson(
        Map<String, dynamic>.from(
          data['company'],
        ),
      );

    } on DioException catch (error) {
      throw Exception(
        _messageFromError(
          error,
          'Impossible de modifier l’entreprise.',
        ),
      );
    }
  }

  static String _messageFromError(
    DioException error,
    String fallback,
  ) {
    final data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message is String &&
        message.trim().isNotEmpty) {
        return message;
        }
    }

    return fallback;
  }
}
