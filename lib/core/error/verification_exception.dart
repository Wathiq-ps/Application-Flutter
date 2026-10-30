import 'package:dio/dio.dart';

import '../constant/strings.dart';

class VerificationException implements Exception {
  final String message;
  final int? statusCode;

  const VerificationException(this.message, {this.statusCode});

  factory VerificationException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return VerificationException(AppStrings.connectionTimeout);
      case DioExceptionType.connectionError:
        return VerificationException(AppStrings.checkInternetConnection);
      default:
        break;
    }

    final status = e.response?.statusCode;
    return VerificationException(_messageForStatus(status), statusCode: status);
  }

  static String _messageForStatus(int? status) {
    switch (status) {
      case 401:
        return AppStrings.sessionExpired;
      case 409:
        return AppStrings.verificationAlreadySubmitted;
      case 413:
        return AppStrings.verificationFileTooLarge;
      case 422:
        return AppStrings.verificationInvalidImages;
      case 429:
        return AppStrings.tooManyAttempts;
      default:
        return AppStrings.somethingWentWrong;
    }
  }

  @override
  String toString() => message;
}