import 'dart:io';

 
class CreatePropertyEntity {
  final String listingType;
  final String type;
  final String city;
  final String district;
  final String? buildingNumber;
  final String latitude;
  final String longitude;
  final double areaSqm;
  final double price;
  final String priceCurrency;
  final String? priceUnit;
  final int? rooms;
  final int? bathrooms;
  final int? floorNumber;
  final List<String>? features;
  final bool? isFurnished;
  final String? description;
  final List<File> photos;
  final List< File> ownershipDocuments;
  final String ownershipDocumentType;

  const CreatePropertyEntity({
    required this.listingType,
    required this.type,
    required this.city,
    required this.district,
    this.buildingNumber,
    required this.latitude,
    required this.longitude,
    required this.areaSqm,
    required this.price,
    required this.priceCurrency,
    this.priceUnit,
    this.rooms,
    this.bathrooms,
    this.floorNumber,
    this.features,
    this.isFurnished,
    this.description,
    required this.photos,
    required this.ownershipDocuments,
    required this.ownershipDocumentType,
  });
}

