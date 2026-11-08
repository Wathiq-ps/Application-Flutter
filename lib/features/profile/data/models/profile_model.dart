import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.identityStatus,
    required super.missingProfileFields,
    required super.profileImageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;

    return ProfileModel(
      id: user['id'] as String,
      name: user['name'] as String? ?? '',
      email: user['email'] as String? ?? '',
      identityStatus: ProfileIdentityStatus.fromApi(
        user['identity_status'] as String?,
      ),
      missingProfileFields:
          (user['missing_profile_fields'] as List? ?? const [])
              .map((field) => field.toString())
              .toList(growable: false),
      profileImageUrl: user['profile_image_url'] as String?,
    );
  }
}
