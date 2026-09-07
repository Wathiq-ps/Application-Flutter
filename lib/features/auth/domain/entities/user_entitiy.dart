class UserEntity {
  final String id;
  final String email;
  final String? phone;
  final String status;
  final String locale;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final String role;

  const UserEntity({
    required this.id,
    required this.email,
    this.phone,
    required this.status,
    required this.locale,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    required this.role,
  });
}