import '../../domain/entities/owner_property_list_item.dart';
import '../../domain/entities/property_status.dart';

class OwnerPropertyListItemModel extends OwnerPropertyListItem {
  const OwnerPropertyListItemModel({
    required super.id,
    required super.title,
    required super.location,
    required super.rooms,
    required super.bathrooms,
    required super.areaSqm,
    required super.price,
    required super.priceUnit,
    super.currency,
    super.pricePeriod,
    required super.status,
    super.imageUrl,
    super.isListingActive,
    super.propertyType,
    super.description,
    super.listingType,
    super.city,
    super.district,
    super.buildingNumber,
    super.latitude,
    super.longitude,
    super.features,
    super.isFurnished,
    super.rentUnit,
    super.floorNumber,
  });

  factory OwnerPropertyListItemModel.fromJson(Map<String, dynamic> json) {
    final double priceNum = _toDouble(json['price']) ?? 0;
    final String currency = json['price_currency'] as String? ?? 'JOD';
    final String? apiStatus = json['status'] as String?;
    final String? apiPriceUnit = json['price_unit'] as String?;

    return OwnerPropertyListItemModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      location: _location(json),
      rooms: (json['rooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      areaSqm: (json['area_sqm'] as num?)?.toInt() ?? 0,
      price: _groupThousands(priceNum),
      priceUnit: '$currency /',
      pricePeriod: _periodSuffix(apiPriceUnit),
      currency: currency,
      status: PropertyStatus.fromApi(apiStatus),
      imageUrl: null,
      isListingActive: apiStatus == 'active',
      propertyType: _capitalize(json['type'] as String? ?? ''),
      description: json['description'] as String? ?? '',
      listingType: json['listing_type'] as String? ?? 'sale',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      buildingNumber: json['building_number']?.toString() ?? '',
      latitude: _toDouble(json['latitude']) ?? 0,
      longitude: _toDouble(json['longitude']) ?? 0,
      features: (json['features'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      isFurnished: json['is_furnished'] as bool? ?? false,
      rentUnit: apiPriceUnit,
      floorNumber: _toInt(json['floor_number']),
    );
  }

  static String _location(Map<String, dynamic> json) {
    final city = json['city'] as String? ?? '';
    final district = json['district'] as String? ?? '';
    if (district.isEmpty) return city;
    if (city.isEmpty) return district;
    return '$district, $city';
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  static String _groupThousands(double price) =>
      price.round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (_) => ',',
      );

  static String _periodSuffix(String? unit) => switch (unit) {
    'per_hour' => ' hour',
    'per_day' => ' day',
    'per_week' => ' week',
    'per_month' => ' month',
    'per_year' => ' year',
    _ => '',
  };

  static double? _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static int? _toInt(dynamic v) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }
}