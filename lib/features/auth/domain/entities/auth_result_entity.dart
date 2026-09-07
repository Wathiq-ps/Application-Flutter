import 'package:mobile/features/auth/domain/entities/user_entitiy.dart';

/// Result of a successful POST /otp/verify call.
class AuthResultEntity {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthResultEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}

/// Result of POST /auth/refresh.
class RefreshResultEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const RefreshResultEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}