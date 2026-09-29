import 'package:mobile/core/cache/cached_fetcher.dart';
import 'package:mobile/core/cache/data_result.dart';
import '../../domain/entities/owner_properties_page.dart';
import '../../domain/entities/owner_property_list_item.dart';
import '../../domain/repositories/owner_property_repository.dart';
import '../data_sources/owner_property_remote_data_source.dart';
import '../models/owner_properties_page_model.dart';
import '../models/owner_property_list_item_model.dart';

class OwnerPropertyRepositoryImpl implements OwnerPropertyRepository {
  const OwnerPropertyRepositoryImpl(this._dataSource, this._cache);

  final OwnerPropertyRemoteDataSource _dataSource;
  final CachedFetcher _cache;

  static const _cacheKey = 'owner_properties_page1';

  @override
  Stream<DataResult<OwnerPropertiesPage>> watchMyProperties() =>
      _cache.load<OwnerPropertiesPage>(
        key: _cacheKey,
        fetchRaw: () => _dataSource.getMyPropertiesRaw(page: 1),
        parse: (raw) => OwnerPropertiesPageModel.fromJson(raw as Map<String, dynamic>),
      );

  @override
  Future<OwnerPropertiesPage> fetchPage(int page) async {
    final raw = await _dataSource.getMyPropertiesRaw(page: page);
    return OwnerPropertiesPageModel.fromJson(raw);
  }

  @override
  Future<void> deleteProperty(String id) => _dataSource.deleteProperty(id);

  @override
  Future<OwnerPropertyListItem> updateProperty(OwnerPropertyListItem property) async {
    final fields = <String, dynamic>{
      '_method': 'PATCH',
      'listing_type': property.listingType,
      'type': property.propertyType.toLowerCase(),
      'city': property.city,
      'district': property.district,
      'building_number': property.buildingNumber,
      'latitude': property.latitude,
      'longitude': property.longitude,
      'area_sqm': property.areaSqm,
      'price': _parsePrice(property.price),
      'price_currency': property.currency,
      'rooms': property.rooms,
      'bathrooms': property.bathrooms,
      'features': property.features,
      'is_furnished': property.isFurnished ? 1 : 0,
      'description': property.description,
    };

    final raw = await _dataSource.updateProperty(property.id, fields);
    return OwnerPropertyListItemModel.fromJson(raw['property'] as Map<String, dynamic>);
  }

  static num _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return num.tryParse(cleaned) ?? 0;
  }
}