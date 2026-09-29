import 'package:equatable/equatable.dart';

import 'property_status.dart';

class OwnerPropertyListItem extends Equatable {
  const OwnerPropertyListItem({
    required this.id,
    required this.title,
    required this.location,
    required this.rooms,
    required this.bathrooms,
    required this.areaSqm,
    required this.price,
    required this.priceUnit,
    this.currency = 'JOD',
    this.pricePeriod = '',
    required this.status,
    this.imageUrl,
    this.isListingActive = true,
    this.propertyType = '',
    this.description = '',
    this.listingType = 'sale',
    this.city = '',
    this.district = '',
    this.buildingNumber = '',
    this.latitude = 0,
    this.longitude = 0,
    this.features = const [],
    this.isFurnished = false,
  });

  final String id;
  final String title;
  final String location;
  final String? imageUrl;
  final int rooms;
  final int bathrooms;
  final int areaSqm;
  final String price;
  final String priceUnit;
  final String currency;
  final PropertyStatus status;
  final bool isListingActive;
  final String pricePeriod;
  final String propertyType;
  final String description;
  final String listingType;
  final String city;
  final String district;
  final String buildingNumber;
  final double latitude;
  final double longitude;
  final List<String> features;
  final bool isFurnished;

  OwnerPropertyListItem copyWith({
    String? id,
    String? title,
    String? location,
    String? imageUrl,
    int? rooms,
    int? bathrooms,
    int? areaSqm,
    String? price,
    String? priceUnit,
    String? currency,
    String? pricePeriod,
    PropertyStatus? status,
    bool? isListingActive,
    String? propertyType,
    String? description,
    String? listingType,
    String? city,
    String? district,
    String? buildingNumber,
    double? latitude,
    double? longitude,
    List<String>? features,
    bool? isFurnished,
  }) {
    return OwnerPropertyListItem(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      areaSqm: areaSqm ?? this.areaSqm,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      currency: currency ?? this.currency,
      pricePeriod: pricePeriod ?? this.pricePeriod,
      status: status ?? this.status,
      isListingActive: isListingActive ?? this.isListingActive,
      propertyType: propertyType ?? this.propertyType,
      description: description ?? this.description,
      listingType: listingType ?? this.listingType,
      city: city ?? this.city,
      district: district ?? this.district,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      features: features ?? this.features,
      isFurnished: isFurnished ?? this.isFurnished,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    location,
    imageUrl,
    rooms,
    bathrooms,
    areaSqm,
    price,
    priceUnit,
    currency,
    pricePeriod,
    status,
    isListingActive,
    propertyType,
    description,
    listingType,
    city,
    district,
    buildingNumber,
    latitude,
    longitude,
    features,
    isFurnished,
  ];
}