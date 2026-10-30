class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final bool isVerified;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
  });
}