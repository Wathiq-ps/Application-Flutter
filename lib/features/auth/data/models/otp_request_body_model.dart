class OtpRequestBodyModel {
  final String email;
  final String status;

  const OtpRequestBodyModel({required this.email, required this.status});

  Map<String, dynamic> toJson() => {'email': email, 'status': status};
}