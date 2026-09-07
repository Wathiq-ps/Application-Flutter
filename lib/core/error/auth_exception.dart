import 'package:dio/dio.dart';
import 'error_mapper.dart';


class AuthException implements Exception {
  final String message;
  final String? errorCode;
  final int? retryAfter;

  const AuthException({required this.message, this.errorCode, this.retryAfter});

  factory AuthException.fromDioException(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final errorCode = data['error_code'] as String?;
      final retryAfter = data['retry_after'] as int?;
      return AuthException(
        message: AppErrorMapper.mapCode(
          errorCode,
          retryAfter: retryAfter,
          fallbackMessage: data['message'] as String?,
        ),
        errorCode: errorCode,
        retryAfter: retryAfter,
      );
    }
    return AuthException(message: AppErrorMapper.mapDioException(e));
  }

  bool get isEmailNotRegistered => errorCode == 'email_not_registered';
  bool get isEmailAlreadyRegistered => errorCode == 'email_already_registered';
  bool get isRateLimited => errorCode == 'otp_rate_limited';
  bool get isOtpNotFound => errorCode == 'otp_not_found';
}