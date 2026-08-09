class CurrentUser {
  const CurrentUser({
    required this.userId,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.companyId,
    required this.companyName,
    required this.role,
  });

  final String userId;
  final String email;
  final String? phone;
  final bool isActive;

  final String companyId;
  final String companyName;

  final String role;

  factory CurrentUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final user =
        json['user'] as Map<String, dynamic>? ?? {};

    final company =
        json['company'] as Map<String, dynamic>? ?? {};

    return CurrentUser(
      userId: user['id'] as String? ?? '',
      email: user['email'] as String? ?? '',
      phone: user['phone'] as String?,
      isActive:
          user['is_active'] == true ||
          user['is_active'] == 1,
      companyId:
          company['id'] as String? ?? '',
      companyName:
          company['name'] as String? ?? '',
      role:
          json['role'] as String? ?? '',
    );
  }
}
