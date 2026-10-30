import 'package:mobile/core/cache/cached_fetcher.dart';
import 'package:mobile/core/cache/data_result.dart';
import '../../../../l10n/generated/app_localizations_ar.dart';
import '../../../../l10n/generated/app_localizations_en.dart';
import '../../domain/entities/listing_toggle_result.dart';
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
    final bool isRent = property.listingType == 'rent';

    final fields = <String, dynamic>{
      '_method': 'PATCH',
      'listing_type': property.listingType,
      'type': _apiType(property.propertyType),
      'area_sqm': property.areaSqm,
      'price': _parsePrice(property.price),
      'price_currency': property.currency,
      'price_unit': isRent ? property.rentUnit : null,
      'rooms': property.rooms,
      'bathrooms': property.bathrooms,
      'floor_number': property.floorNumber,
      'features': property.features,
      'is_furnished': property.isFurnished ? 1 : 0,
      'description': property.description,
    };

    final raw = await _dataSource.updateProperty(property.id, fields);
    return _tryProperty(raw) ?? property;
  }

  @override
  Future<ListingToggleResult> publishProperty(String id) async =>
      _toggleResult(await _dataSource.publishProperty(id));

  @override
  Future<ListingToggleResult> suspendProperty(String id) async =>
      _toggleResult(await _dataSource.suspendProperty(id));

  ListingToggleResult _toggleResult(Map<String, dynamic> raw) =>
      ListingToggleResult(
        message: raw['message'] is String ? raw['message'] as String : '',
        property: _tryProperty(raw),
      );

  OwnerPropertyListItem? _tryProperty(Map<String, dynamic> raw) {
    try {
      Map<String, dynamic>? json;
      if (raw['property'] is Map) {
        json = Map<String, dynamic>.from(raw['property'] as Map);
      } else if (raw['data'] is Map) {
        final data = Map<String, dynamic>.from(raw['data'] as Map);
        json = data['property'] is Map
            ? Map<String, dynamic>.from(data['property'] as Map)
            : data;
      }
      if (json == null || json['id'] == null) return null;
      return OwnerPropertyListItemModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static String _apiType(String display) {
    final value = display.trim().toLowerCase();
    for (final l in [AppLocalizationsEn(), AppLocalizationsAr()]) {
      final labels = <String, String>{
        'apartment': l.propertyApartment,
        'house': l.propertyHouse,
        'villa': l.propertyVilla,
        'land': l.propertyLand,
        'shop': l.propertyShop,
      };
      for (final e in labels.entries) {
        if (e.value.trim().toLowerCase() == value) return e.key;
      }
    }
    return value;
  }

  static num _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return num.tryParse(cleaned) ?? 0;
  }
}