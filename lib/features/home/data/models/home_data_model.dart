import 'package:mobile/features/property/data/models/property_model.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../domain/entities/home_data_entity.dart';

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({required super.topRated, required super.featured});

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      topRated: _parse(json['top_rated']),
      featured: _parse(json['featured']),
    );
  }

  static List<PropertyEntity> _parse(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map<PropertyEntity>(PropertyModel.fromJson)
        .toList();
  }
}