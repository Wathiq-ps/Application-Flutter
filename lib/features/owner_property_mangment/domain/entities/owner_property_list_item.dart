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
  ];
}