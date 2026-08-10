class Company {
  const Company({
    required this.id,
    required this.name,
    this.legalName,
    this.contactName,
    this.siret,
    required this.alphatangoOperatorNumber,
    this.email,
    this.phone,
    this.websiteUrl,
    this.addressLine1,
    this.addressLine2,
    this.postalCode,
    this.city,
    required this.country,
    this.logoPath,
    this.signaturePath,
    required this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? legalName;
  final String? contactName;

  final String? siret;
  final String alphatangoOperatorNumber;

  final String? email;
  final String? phone;
  final String? websiteUrl;

  final String? addressLine1;
  final String? addressLine2;
  final String? postalCode;
  final String? city;
  final String country;

  final String? logoPath;
  final String? signaturePath;

  final bool isActive;

  final String? notes;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Company.fromJson(
    Map<String, dynamic> json,
  ) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      legalName: json['legal_name'] as String?,
      contactName: json['contact_name'] as String?,
      siret: json['siret'] as String?,
      alphatangoOperatorNumber:
      json['alphatango_operator_number'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      websiteUrl: json['website_url'] as String?,
      addressLine1: json['address_line_1'] as String?,
      addressLine2: json['address_line_2'] as String?,
      postalCode: json['postal_code'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String? ?? 'France',
      logoPath: json['logo_path'] as String?,
      signaturePath: json['signature_path'] as String?,
      isActive: json['is_active'] == true ||
      json['is_active'] == 1,
      notes: json['notes'] as String?,
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
    );
  }

  static DateTime? _date(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }
}
