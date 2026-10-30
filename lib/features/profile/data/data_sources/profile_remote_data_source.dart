import 'package:dio/dio.dart';
import '../../../../core/constant/api_constants.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/services/secure_storage_service.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getProfileJson();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorageService _secureStorage;

  @override
  Future<Map<String, dynamic>> getProfileJson() async {
    try {
      final token = await _secureStorage.getAccessToken();
      final response = await _dio.get(
        ApiConstants.profileEndpoint,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}