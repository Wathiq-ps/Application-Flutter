import 'package:mobile/core/cache/data_result.dart';
import '../entities/owner_properties_page.dart';
import '../entities/owner_property_list_item.dart';

abstract class OwnerPropertyRepository {

  Stream<DataResult<OwnerPropertiesPage>> watchMyProperties();

  Future<OwnerPropertiesPage> fetchPage(int page);

  Future<void> deleteProperty(String id);

  Future<OwnerPropertyListItem> updateProperty(OwnerPropertyListItem property);
}