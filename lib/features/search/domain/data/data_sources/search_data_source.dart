import 'package:dio/dio.dart';
import 'package:mobile/core/error/api_exception.dart';

import '../../../../../core/constant/api_constants.dart';

abstract class SearchDataSource {
  Future<Map<String, dynamic>> searchJson({
    String query = '',
    String? listingType,
    int page = 1,
  });
}

class SearchDataSourceImpl implements SearchDataSource {
  const SearchDataSourceImpl(this._dio);
  final Dio _dio;

  static const String _queryKey = 'q';

  @override
  Future<Map<String, dynamic>> searchJson({
    String query = '',
    String? listingType,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.searchPropertiesEndpoint,
        queryParameters: {
          'page': page,
          if (query.isNotEmpty) _queryKey: query,
          if (listingType != null) 'listing_type': listingType,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}