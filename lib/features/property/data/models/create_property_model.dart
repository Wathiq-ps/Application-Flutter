import 'dart:io';

import '../../domain/entities/create_property_entity.dart';

class CreatePropertyModel extends CreatePropertyEntity {
  const CreatePropertyModel({
    required super.listingType,
    required super.type,
    required super.city,
    required super.district,
    super.buildingNumber,
    required super.latitude,
    required super.longitude,
    required super.areaSqm,
    required super.price,
    required super.priceCurrency,
    super.priceUnit,
    super.rooms,
    super.bathrooms,
    super.floorNumber,
    super.features,
    super.isFurnished,
    super.description,
    required super.photos,
    required super.ownershipDocuments,
    required super.ownershipDocumentType,
  });

  factory CreatePropertyModel.fromJson(Map<String, dynamic> json) {
    return CreatePropertyModel(
      listingType:
          (json['listing_type'] ?? json['listingType']) as String? ?? '',
      type: json['type'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      buildingNumber:
          (json['building_number'] ?? json['buildingNumber'])?.toString(),
      latitude: (json['latitude'] ?? '')?.toString() ?? '',
      longitude: (json['longitude'] ?? '')?.toString() ?? '',
      areaSqm:
          ((json['area_sqm'] ?? json['areaSqm']) as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceCurrency:
          (json['price_currency'] ?? json['priceCurrency']) as String? ?? '',
      priceUnit: (json['price_unit'] ?? json['priceUnit']) as String?,
      rooms: (json['rooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      floorNumber: (json['floor_number'] as num?)?.toInt(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      isFurnished: (json['is_furnished'] ?? json['isFurnished']) as bool?,
      description: json['description'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => File(e.toString()))
              .toList() ??
          const [],
      ownershipDocuments: (json['ownership_documents'] as List<dynamic>?)
              ?.map((e) => File(e.toString()))
              .toList() ??
          const [],
      ownershipDocumentType:
          (json['ownership_document_type'] ?? json['ownershipDocumentType'])
                  as String? ??
              '',
    );
  }

  factory CreatePropertyModel.fromEntity(CreatePropertyEntity entity) {
    return CreatePropertyModel(
      listingType: entity.listingType,
      type: entity.type,
      city: entity.city,
      district: entity.district,
      buildingNumber: entity.buildingNumber,
      latitude: entity.latitude,
      longitude: entity.longitude,
      areaSqm: entity.areaSqm,
      price: entity.price,
      priceCurrency: entity.priceCurrency,
      priceUnit: entity.priceUnit,
      rooms: entity.rooms,
      bathrooms: entity.bathrooms,
      floorNumber: entity.floorNumber,
      features: entity.features,
      isFurnished: entity.isFurnished,
      description: entity.description,
      photos: entity.photos,
      ownershipDocuments: entity.ownershipDocuments,
      ownershipDocumentType: entity.ownershipDocumentType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listing_type': listingType,
      'type': type,
      'city': city,
      'district': district,
      'building_number': buildingNumber,
      'latitude': latitude,
      'longitude': longitude,
      'area_sqm': areaSqm,
      'price': price,
      'price_currency': priceCurrency,
      if (priceUnit != null && listingType.toLowerCase() != 'sale')
        'price_unit': priceUnit,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'floor_number': floorNumber,
      'features': features,
      'is_furnished': isFurnished,
      'description': description,
      'photos': photos.map((e) => e.path).toList(),
      'ownership_documents':
          ownershipDocuments.map((e) => e.path).toList(),
      'ownership_document_type': ownershipDocumentType,
    };
  }

  CreatePropertyEntity toEntity() {
    return CreatePropertyEntity(
      listingType: listingType,
      type: type,
      city: city,
      district: district,
      buildingNumber: buildingNumber,
      latitude: latitude,
      longitude: longitude,
      areaSqm: areaSqm,
      price: price,
      priceCurrency: priceCurrency,
      priceUnit: priceUnit,
      rooms: rooms,
      bathrooms: bathrooms,
      floorNumber: floorNumber,
      features: features,
      isFurnished: isFurnished,
      description: description,
      photos: photos,
      ownershipDocuments: ownershipDocuments,
      ownershipDocumentType: ownershipDocumentType,
    );
  }
}

