class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://wathiq-back.up.railway.app';

  // Add your endpoints here later.
  static const String otpRequestEndpoint = '/api/v1/auth/otp/request';
  static const String otpVerifyEndpoint = '/api/v1/auth/otp/verify';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String homeEndpoint = '/api/v1/properties/home';
  static const String createPropertyEndPoint = '/api/v1/properties';
  static const String myPropertiesEndpoint = '/api/v1/properties/my-properties';
  static String propertyByIdEndpoint(String id) => '/api/v1/properties/$id';
}
