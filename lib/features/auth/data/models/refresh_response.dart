class RefreshResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const RefreshResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }
}