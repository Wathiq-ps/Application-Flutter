import 'package:dio/dio.dart';
import 'package:mobile/core/constant/strings.dart';

class AppErrorMapper {
  AppErrorMapper._();

  static String mapCode(
      String? errorCode, {
        int? retryAfter,
        String? fallbackMessage,
      }) {
    switch (errorCode) {
      case 'email_not_registered':
        return AppStrings.emailNotRegistered;

      case 'email_already_registered':
        return AppStrings.emailAlreadyRegistered;

      case 'otp_not_found':
        return AppStrings.otpExpiredOrInvalid;

      case 'otp_rate_limited':
        if (retryAfter != null && retryAfter > 0) {
          return AppStrings.tooManyAttemptsWithRetry(retryAfter);
        }

        return AppStrings.tooManyAttempts;
    }
    if (fallbackMessage != null && fallbackMessage.trim().isNotEmpty) {
      return mapMessage(fallbackMessage);
    }

    return AppStrings.somethingWentWrong;
  }

  static String mapMessage(String backendMessage) {
    final message = backendMessage.toLowerCase().trim();

    if (message.isEmpty) {
      return AppStrings.somethingWentWrong;
    }

    if (message.contains('expired') && message.contains('otp')) {
      return AppStrings.otpExpired;
    }

    if (message.contains('invalid') && message.contains('otp')) {
      return AppStrings.incorrectOtp;
    }

    if (message.contains('blocked') ||
        message.contains('suspended')) {
      return AppStrings.accountSuspended;
    }

    return AppStrings.somethingWentWrong;
  }

  static String mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return AppStrings.checkInternetConnection;

      default:
        break;
    }

    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      return mapCode(
        data['error_code'] as String?,
        retryAfter: data['retry_after'] as int?,
        fallbackMessage: data['message'] as String?,
      );
    }

    return AppStrings.somethingWentWrong;
  }
}