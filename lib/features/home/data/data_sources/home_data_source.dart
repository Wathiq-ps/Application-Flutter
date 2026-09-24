import 'package:dio/dio.dart';
import 'package:mobile/core/error/api_exception.dart';

import '../../../../core/constant/api_constants.dart';

abstract class HomeDataSource {
  Future<Map<String, dynamic>> getHomeJson();
}

class HomeDataSourceImpl implements HomeDataSource {
  final Dio _dio;
  const HomeDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> getHomeJson() async {
    try {
      final response = await _dio.get(ApiConstants.homeEndpoint);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}