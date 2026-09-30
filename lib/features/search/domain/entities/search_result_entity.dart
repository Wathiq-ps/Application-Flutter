import 'package:mobile/features/property/domain/entities/property_entity.dart';

class SearchResultEntity {
  final List<PropertyEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const SearchResultEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}