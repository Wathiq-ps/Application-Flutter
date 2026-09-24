import 'package:mobile/features/property/domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.reference,
    super.publishedAt,
    required super.listingType,
    required super.type,
    required super.title,
    required super.description,
    required super.city,
    required super.district,
    required super.buildingNumber,
    required super.addressLine,
    required super.areaSqm,
    required super.price,
    required super.priceCurrency,
    super.priceUnit,
    required super.rooms,
    required super.bathrooms,
    required super.floorNumber,
    required super.isFurnished,
    required super.features,
    required super.photos,
    super.averageRating,
    required super.ratingsCount,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      reference: json['reference'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
      listingType: PropertyListingType.fromApi(json['listing_type'] as String?),
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      buildingNumber: json['building_number']?.toString() ?? '',
      addressLine: json['address_line'] as String? ?? '',
      areaSqm: _toDouble(json['area_sqm']) ?? 0,
      price: _toDouble(json['price']) ?? 0,
      priceCurrency: json['price_currency'] as String? ?? '',
      priceUnit: json['price_unit'] as String?,
      rooms: (json['rooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      floorNumber: (json['floor_number'] as num?)?.toInt() ?? 0,
      isFurnished: json['is_furnished'] as bool? ?? false,
      features: _stringList(json['features']),
      photos: _parsePhotos(json['photos']),
      averageRating: _toDouble(json['average_rating']),
      ratingsCount: (json['ratings_count'] as num?)?.toInt() ?? 0,
    );
  }

  static double? _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static List<String> _stringList(dynamic raw) =>
      raw is List ? raw.map((e) => e.toString()).toList() : const [];

  static List<String> _parsePhotos(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map<String?>((e) {
      if (e is String) return e;
      if (e is Map) return (e['url'] ?? e['path'])?.toString();
      return null;
    })
        .whereType<String>()
        .toList();
  }
}