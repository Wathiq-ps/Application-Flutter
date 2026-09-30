enum ProfileDocumentType {
  id,
  passport;

  String get apiValue => this == ProfileDocumentType.passport ? 'passport' : 'id';

  static ProfileDocumentType fromApi(String? value) =>
      value == 'passport' ? ProfileDocumentType.passport : ProfileDocumentType.id;
}

class EditProfileUserEntity {
  const EditProfileUserEntity({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.nationality,
    required this.documentType,
    this.documentNumber,
    this.dateOfBirth,
    required this.status,
    required this.locale,
    required this.hasSignature,
    required this.profileComplete,
    required this.missingProfileFields,
  });

  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? nationality;
  final ProfileDocumentType documentType;
  final String? documentNumber;
  final DateTime? dateOfBirth;
  final String status;
  final String locale;
  final bool hasSignature;
  final bool profileComplete;
  final List<String> missingProfileFields;
}