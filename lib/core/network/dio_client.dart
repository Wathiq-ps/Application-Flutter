import 'package:dio/dio.dart';
import 'package:mobile/core/services/secure_storage_service.dart';

import '../constant/api_constants.dart';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  late final Dio dio = _createDio();

  final SecureStorageService _secureStorage = const SecureStorageService();

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
