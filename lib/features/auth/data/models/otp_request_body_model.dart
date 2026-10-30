class OtpRequestBodyModel {
  final String email;
  final String status;

  const OtpRequestBodyModel({required this.email, required this.status});

  Map<String, dynamic> toJson() {final Map<String, dynamic> json = {'email': email, 'status': status,};

    if (status == 'register') {
      json['role'] = 'user';
    }

    return json;
  }
}