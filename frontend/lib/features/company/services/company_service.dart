import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/company.dart';

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

  static Future<Company> updateCompany({
    required String name,
    String? legalName,
    String? contactName,
    String? siret,
    required String alphatangoOperatorNumber,
    String? email,
    String? phone,
    String? websiteUrl,
    String? addressLine1,
    String? addressLine2,
    String? postalCode,
    String? city,
    required String country,
    String? notes,
  }) async {
    try {
      final response =
      await ApiClient.instance.put(
        '/auth/company',
        data: {
          'name': name.trim(),
          'legal_name': _nullIfEmpty(legalName),
          'contact_name': _nullIfEmpty(contactName),
          'siret': _nullIfEmpty(siret),
          'alphatango_operator_number':
          alphatangoOperatorNumber.trim(),
          'email': _nullIfEmpty(email),
          'phone': _nullIfEmpty(phone),
          'website_url': _nullIfEmpty(websiteUrl),
          'address_line_1':
          _nullIfEmpty(addressLine1),
          'address_line_2':
          _nullIfEmpty(addressLine2),
          'postal_code':
          _nullIfEmpty(postalCode),
          'city': _nullIfEmpty(city),
          'country': country.trim(),
          'notes': _nullIfEmpty(notes),
        },
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
          data['company'] as Map,
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

  static String? _nullIfEmpty(
    String? value,
  ) {
    if (value == null) {
      return null;
    }

    final trimmed = value.trim();

    return trimmed.isEmpty
    ? null
    : trimmed;
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
