import 'package:dio/dio.dart';

class AppErrorMapper {
  AppErrorMapper._();

  static const String genericError = 'Something went wrong. Please try again';


  static String mapCode(
      String? errorCode, {
        int? retryAfter,
        String? fallbackMessage,
      }) {
    switch (errorCode) {
      case 'email_not_registered':
        return 'This email is not registered. Please register first';

      case 'email_already_registered':
        return 'This email is already registered. Please login instead';

      case 'otp_not_found':
        return 'This code has expired or is invalid. Please request a new one';

      case 'otp_rate_limited':
        if (retryAfter != null && retryAfter > 0) {
          return 'Too many attempts. Please wait ${retryAfter}s before trying again';
        }
        return 'Too many attempts. Please wait before trying again';
    }

    // No recognized code — fall back to message-matching, or generic.
    if (fallbackMessage != null && fallbackMessage.trim().isNotEmpty) {
      return mapMessage(fallbackMessage);
    }
    return genericError;
  }

  static String mapMessage(String backendMessage) {
    final msg = backendMessage.toLowerCase().trim();

    if (msg.isEmpty) return genericError;

    if (msg.contains('expired') && msg.contains('otp')) {
      return 'This code has expired. Please request a new one';
    }
    if (msg.contains('invalid') && msg.contains('otp')) {
      return 'The code you entered is incorrect';
    }
    if (msg.contains('blocked') || msg.contains('suspended')) {
      return 'Your account has been suspended';
    }

    return genericError;
  }

  static String mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Check your internet connection and try again';
      default:
        break;
    }

    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return mapCode(
        data['error_code'] as String?,
        retryAfter: data['retry_after'] as int?,
        fallbackMessage: data['message'] as String?,
      );
    }
    return genericError;
  }
}