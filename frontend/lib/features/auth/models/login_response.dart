class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.userId,
    required this.email,
  });

  final String accessToken;
  final int expiresIn;
  final String userId;
  final String email;

  factory LoginResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final user =
        json['user'] as Map<String, dynamic>? ?? {};

    return LoginResponse(
      accessToken:
          json['access_token'] as String,
      expiresIn:
          (json['expires_in'] as num?)?.toInt() ?? 0,
      userId:
          user['id'] as String? ?? '',
      email:
          user['email'] as String? ?? '',
    );
  }
}
