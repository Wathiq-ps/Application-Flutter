import 'package:dio/dio.dart';
import '../../../../core/constant/api_constants.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/error/api_exception.dart';

abstract class OwnerPropertyRemoteDataSource {
  Future<Map<String, dynamic>> getMyPropertiesRaw({required int page});
  Future<void> deleteProperty(String id);
  Future<Map<String, dynamic>> updateProperty(String id, Map<String, dynamic> fields);
  Future<Map<String, dynamic>> publishProperty(String id);
  Future<Map<String, dynamic>> suspendProperty(String id);
}

class OwnerPropertyRemoteDataSourceImpl implements OwnerPropertyRemoteDataSource {
  const OwnerPropertyRemoteDataSourceImpl(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorageService _secureStorage;

  Future<Options> _authOptions() async {
    final token = await _secureStorage.getAccessToken();
    return Options(headers: {if (token != null) 'Authorization': 'Bearer $token'});
  }

  Map<String, dynamic> _map(Response<dynamic> r) =>
      r.data is Map ? Map<String, dynamic>.from(r.data as Map) : <String, dynamic>{};

  @override
  Future<Map<String, dynamic>> getMyPropertiesRaw({required int page}) async {
    try {
      final response = await _dio.get(
        ApiConstants.myPropertiesEndpoint,
        queryParameters: {'page': page},
        options: await _authOptions(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    try {
      await _dio.delete(
        ApiConstants.propertyByIdEndpoint(id),
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateProperty(
      String id,
      Map<String, dynamic> fields,
      ) async {
    try {
      final entries = <MapEntry<String, String>>[];
      fields.forEach((key, value) {
        if (value == null) return;
        if (value is List) {
          for (var i = 0; i < value.length; i++) {
            entries.add(MapEntry('$key[$i]', value[i].toString()));
          }
        } else {
          entries.add(MapEntry(key, value.toString()));
        }
      });

      final response = await _dio.post(
        ApiConstants.propertyByIdEndpoint(id),
        data: FormData()..fields.addAll(entries),
        options: await _authOptions(),
      );
      return _map(response);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> publishProperty(String id) async {
    try {
      final response = await _dio.post(
        ApiConstants.publishPropertyEndpoint(id),
        options: await _authOptions(),
      );
      return _map(response);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> suspendProperty(String id) async {
    try {
      final response = await _dio.get(
        ApiConstants.suspendPropertyEndpoint(id),
        options: await _authOptions(),
      );
      return _map(response);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}