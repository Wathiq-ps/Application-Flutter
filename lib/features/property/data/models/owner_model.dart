class OwnerModel {
  final String id;
  final String name;
  final bool isVerified;
  final String memberSince;
  const OwnerModel({
    required this.id,
    required this.name,
    required this.isVerified,
    required this.memberSince,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      memberSince: json['member_since']?.toString() ?? '',
    );
  }
}
