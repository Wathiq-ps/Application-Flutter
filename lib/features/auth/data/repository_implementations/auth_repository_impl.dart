import '../../domain/entities/auth_result_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<int> requestOtp({required String email, required String status}) async {
    final response = await _dataSource.requestOtp(email: email, status: status);
    return response.expiresInMinutes;
  }

  @override
  Future<AuthResultEntity> verifyOtp({required String email, required String code}) async {
    final result = await _dataSource.verifyOtp(email: email, code: code);

    // TODO: persist tokens here, e.g.:
    // await secureStorage.write(key: StorageKeys.accessToken, value: result.accessToken);
    // await secureStorage.write(key: StorageKeys.refreshToken, value: result.refreshToken);

    return AuthResultEntity(
      user: result.user,
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
      expiresIn: result.expiresIn,
    );
  }

  @override
  Future<RefreshResultEntity> refreshToken({required String refreshToken}) async {
    final result = await _dataSource.refreshToken(refreshToken: refreshToken);
    return RefreshResultEntity(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
      expiresIn: result.expiresIn,
    );
  }
}