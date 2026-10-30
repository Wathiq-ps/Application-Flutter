import 'package:dio/dio.dart';

import '../constant/strings.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(AppStrings.connectionTimeout);
      case DioExceptionType.connectionError:
        return ApiException(AppStrings.checkInternetConnection);
      default:
        break;
    }

    final status = e.response?.statusCode;
    if (status == 401) {
      return ApiException(AppStrings.sessionExpired, statusCode: 401);
    }
    if (status == 429) {
      return ApiException(AppStrings.tooManyAttempts, statusCode: 429);
    }

    final data = e.response?.data;
    final server = data is Map ? data['message']?.toString() : null;
    return ApiException(
      (server != null && server.trim().isNotEmpty)
          ? server
          : AppStrings.somethingWentWrong,
      statusCode: status,
    );
  }

  @override
  String toString() => message;
}