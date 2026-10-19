import 'package:dio/dio.dart';
import '../services/secure_storage_service.dart';
import 'api_locale.dart';

class ApiHeadersInterceptor extends Interceptor {
  ApiHeadersInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = ApiLocale.code;

    if (!options.headers.containsKey('Authorization')) {
      final token = await _storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}