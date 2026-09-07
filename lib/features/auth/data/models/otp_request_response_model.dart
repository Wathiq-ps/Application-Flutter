class OtpRequestResponseModel {
  final String message;
  final int expiresInMinutes;

  const OtpRequestResponseModel({required this.message, required this.expiresInMinutes});

  factory OtpRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestResponseModel(
      message: json['message'] as String? ?? '',
      expiresInMinutes: json['expires_in_minutes'] as int? ?? 0,
    );
  }
}