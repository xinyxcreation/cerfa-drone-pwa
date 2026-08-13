class CurrentUser {
  const CurrentUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.companyId,
    required this.companyName,
    required this.role,
    required this.isOwner,
    required this.isManager,
    required this.isPilot,
  });

  final String userId;

  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  final bool isActive;

  final String companyId;
  final String companyName;

  final String role;

  final bool isOwner;
  final bool isManager;
  final bool isPilot;

  factory CurrentUser.fromJson(
    Map<String, dynamic> json,
  ) {
    final user =
        json['user'] as Map<String, dynamic>? ?? {};

    final company =
        json['company'] as Map<String, dynamic>? ?? {};

    return CurrentUser(
      userId:
          user['id'] as String? ?? '',

      firstName:
          user['first_name'] as String? ?? '',

      lastName:
          user['last_name'] as String? ?? '',

      email:
          user['email'] as String? ?? '',

      phone:
          user['phone'] as String?,

      isActive:
          user['is_active'] == true ||
          user['is_active'] == 1,

      companyId:
          company['id'] as String? ?? '',

      companyName:
          company['name'] as String? ?? '',

      role:
          json['role'] as String? ?? '',

      isOwner:
          json['is_owner'] == true,

      isManager:
          json['is_manager'] == true,

      isPilot:
          json['is_pilot'] == true,
    );
  }
}
