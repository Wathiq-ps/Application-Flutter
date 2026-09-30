import '../../domain/entities/owner_properties_page.dart';
import 'owner_property_list_item_model.dart';

class OwnerPropertiesPageModel extends OwnerPropertiesPage {
  const OwnerPropertiesPageModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory OwnerPropertiesPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? const [];
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};

    return OwnerPropertiesPageModel(
      items: data
          .whereType<Map<String, dynamic>>()
          .map(OwnerPropertyListItemModel.fromJson)
          .toList(),
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      total: (meta['total'] as num?)?.toInt() ?? data.length,
    );
  }
}