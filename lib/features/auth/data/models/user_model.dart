
import '../../domain/entities/user_entitiy.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.phone,
    required super.status,
    required super.locale,
    super.emailVerifiedAt,
    super.phoneVerifiedAt,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      locale: json['locale'] as String,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'] as String)
          : null,
      phoneVerifiedAt: json['phone_verified_at'] != null
          ? DateTime.tryParse(json['phone_verified_at'] as String)
          : null,
      role: json['role'] as String,
    );
  }
}