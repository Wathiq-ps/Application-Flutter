import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('The connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException('No internet connection.');
      default:
        final data = e.response?.data;
        final serverMessage = data is Map ? data['message']?.toString() : null;
        return ApiException(
          serverMessage ?? 'Something went wrong. Please try again.',
          statusCode: e.response?.statusCode,
        );
    }
  }

  @override
  String toString() => message;
}