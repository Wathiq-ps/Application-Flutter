class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://wathiq-back.up.railway.app';

  // Add your endpoints here later.
  static const String otpRequestEndpoint = '/api/v1/auth/otp/request';
  static const String otpVerifyEndpoint = '/api/v1/auth/otp/verify';
  static const String refreshTokenEndpoint = '/auth/refresh';
}