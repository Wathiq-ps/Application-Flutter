enum VerificationStatus { pending, approved, rejected, unknown }

class VerificationModel {
  final String? id;
  final String? idImage;
  final String? selfieImage;
  final VerificationStatus status;
  final String? rejectionReason;

  const VerificationModel({
    this.id,
    this.idImage,
    this.selfieImage,
    this.status = VerificationStatus.unknown,
    this.rejectionReason,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      id: json['id']?.toString(),
      idImage: json['id_image']?.toString(),
      selfieImage: json['selfie_image']?.toString(),
      status: _parseStatus(json['status']),
      rejectionReason: json['rejection_reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_image': idImage,
      'selfie_image': selfieImage,
      'status': status.name,
      'rejection_reason': rejectionReason,
    };
  }

  static VerificationStatus _parseStatus(dynamic value) {
    switch (value?.toString()) {
      case 'pending':
        return VerificationStatus.pending;

      case 'approved':
        return VerificationStatus.approved;

      case 'rejected':
        return VerificationStatus.rejected;

      default:
        return VerificationStatus.unknown;
    }
  }
}
