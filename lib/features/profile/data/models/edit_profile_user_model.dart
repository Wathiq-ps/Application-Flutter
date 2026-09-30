import '../../domain/entities/edit_profile_user_entity.dart';

class EditProfileUserModel extends EditProfileUserEntity {
  const EditProfileUserModel({
    required super.id,
    required super.email,
    super.phone,
    required super.name,
    super.nationality,
    required super.documentType,
    super.documentNumber,
    super.dateOfBirth,
    required super.status,
    required super.locale,
    required super.hasSignature,
    required super.profileComplete,
    required super.missingProfileFields,
  });

  factory EditProfileUserModel.fromJson(Map<String, dynamic> json) {
    return EditProfileUserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      name: json['name'] as String? ?? '',
      nationality: json['nationality'] as String?,
      documentType: ProfileDocumentType.fromApi(json['document_type'] as String?),
      documentNumber: json['document_number'] as String?,
      dateOfBirth: DateTime.tryParse(json['date_of_birth'] as String? ?? ''),
      status: json['status'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en',
      hasSignature: json['has_signature'] as bool? ?? false,
      profileComplete: json['profile_complete'] as bool? ?? false,
      missingProfileFields:
      (json['missing_profile_fields'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }
}