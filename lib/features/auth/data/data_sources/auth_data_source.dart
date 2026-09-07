import 'package:dio/dio.dart';
import '../../../../core/constant/api_constants.dart';
import '../../../../core/error/auth_exception.dart';
import '../models/auth_result_model.dart';
import '../models/otp_request_body_model.dart';
import '../models/otp_request_response_model.dart';
import '../models/refresh_response.dart';

abstract class AuthDataSource {
  Future<OtpRequestResponseModel> requestOtp({required String email, required String status});
  Future<AuthResultModel> verifyOtp({required String email, required String code});
  Future<RefreshResponseModel> refreshToken({required String refreshToken});
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  const AuthDataSourceImpl(this._dio);

  @override
  Future<OtpRequestResponseModel> requestOtp({
    required String email,
    required String status,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.otpRequestEndpoint,
        data: OtpRequestBodyModel(email: email, status: status).toJson(),
      );
      return OtpRequestResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AuthException.fromDioException(e);
    }
  }

  @override
  Future<AuthResultModel> verifyOtp({required String email, required String code}) async {
    try {
      final response = await _dio.post(
        ApiConstants.otpVerifyEndpoint,
        data: {'email': email, 'code': code},
      );
      return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AuthException.fromDioException(e);
    }
  }

  @override
  Future<RefreshResponseModel> refreshToken({required String refreshToken}) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );
      return RefreshResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AuthException.fromDioException(e);
    }
  }
}