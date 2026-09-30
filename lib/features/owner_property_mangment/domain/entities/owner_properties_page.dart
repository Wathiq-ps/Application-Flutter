import 'owner_property_list_item.dart';

class OwnerPropertiesPage {
  const OwnerPropertiesPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<OwnerPropertyListItem> items;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasMore => currentPage < lastPage;
}