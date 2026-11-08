enum ProfileIdentityStatus {
  pending,
  underReview,
  approved,
  rejected;

  static ProfileIdentityStatus fromApi(String? value) {
    switch (value) {
      case 'under_review':
        return ProfileIdentityStatus.underReview;
      case 'approved':
        return ProfileIdentityStatus.approved;
      case 'rejected':
        return ProfileIdentityStatus.rejected;
      case 'pending':
      default:
        return ProfileIdentityStatus.pending;
    }
  }
}

class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final ProfileIdentityStatus identityStatus;
  final List<String> missingProfileFields;
  final String? profileImageUrl;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.identityStatus,
    this.missingProfileFields = const [],
    this.profileImageUrl,
  });

  bool get isProfileComplete => missingProfileFields.isEmpty;
}
