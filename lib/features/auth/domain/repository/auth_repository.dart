import '../entities/auth_result_entity.dart';

abstract class AuthRepository {
  Future<int> requestOtp({required String email, required String status});

  Future<AuthResultEntity> verifyOtp({required String email, required String code});

  Future<RefreshResultEntity> refreshToken({required String refreshToken});
}