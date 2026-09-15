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
     this.pricePeriod = '',
    required this.status,
    this.imageUrl,
    this.isListingActive = true,
  });

  final String id;
  final String title;
  final String location;

  /// Nullable: falls back to a default asset in the UI when empty/null.
  final String? imageUrl;

  final int rooms;
  final int bathrooms;
  final int areaSqm;
  final String price;
  final String priceUnit;
  final PropertyStatus status;
  final bool isListingActive;
  final String pricePeriod;

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
    String? PricePeriod,
    PropertyStatus? status,
    bool? isListingActive,
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
      pricePeriod: pricePeriod ?? this.pricePeriod,
      status: status ?? this.status,
      isListingActive: isListingActive ?? this.isListingActive,
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
    pricePeriod,
    status,
    isListingActive,
  ];
}