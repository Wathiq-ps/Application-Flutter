import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isVerified,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;

    return ProfileModel(
      id: user['id'] as String,
      name: user['name'] as String? ?? '',
      email: user['email'] as String? ?? '',
      isVerified: user['profile_complete'] as bool? ?? false,
    );
  }
}