enum PropertyListingType {
  sale,
  rent,
  unknown;

  static PropertyListingType fromApi(String? value) => switch (value) {
    'sale' => PropertyListingType.sale,
    'rent' => PropertyListingType.rent,
    _ => PropertyListingType.unknown,
  };
}

class PropertyEntity {
  final String id;
  final String reference;
  final DateTime? publishedAt;
  final PropertyListingType listingType;
  final String type;
  final String title;
  final String description;
  final String city;
  final String district;
  final String buildingNumber;
  final String addressLine;
  final double areaSqm;
  final double price;
  final String priceCurrency;
  final String? priceUnit;
  final int rooms;
  final int bathrooms;
  final int floorNumber;
  final bool isFurnished;
  final List<String> features;
  final List<String> photos;
  final double? averageRating;
  final int ratingsCount;

  const PropertyEntity({
    required this.id,
    required this.reference,
    this.publishedAt,
    required this.listingType,
    required this.type,
    required this.title,
    required this.description,
    required this.city,
    required this.district,
    required this.buildingNumber,
    required this.addressLine,
    required this.areaSqm,
    required this.price,
    required this.priceCurrency,
    this.priceUnit,
    required this.rooms,
    required this.bathrooms,
    required this.floorNumber,
    required this.isFurnished,
    required this.features,
    required this.photos,
    this.averageRating,
    required this.ratingsCount,
  });

  String? get coverPhoto => photos.isEmpty ? null : photos.first;
  String get locationLabel => district.isEmpty ? city : '$district, $city';
}