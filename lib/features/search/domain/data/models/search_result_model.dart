import 'package:mobile/features/property/data/models/property_model.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../entities/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final items = (json['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map<PropertyEntity>(PropertyModel.fromJson)
        .toList();

    return SearchResultModel(
      items: items,
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      total: (meta['total'] as num?)?.toInt() ?? items.length,
    );
  }
}