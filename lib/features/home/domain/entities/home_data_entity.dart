import 'package:mobile/features/property/domain/entities/property_entity.dart';

class HomeDataEntity {
  final List<PropertyEntity> topRated;
  final List<PropertyEntity> featured;

  const HomeDataEntity({required this.topRated, required this.featured});
}