import 'dart:io';

import 'package:file_picker/file_picker.dart';

enum CreatePropertyStatus {
  initial,
  validationError,
  step1Saved,
  step2Saved,
  step3Saved,
  step4Saved,
  step5Saved,
  createError,
  created,
}

class CreatePropertyState {
  final String listingType;
  final String type;
  final String? customType;
  final String city;
  final String district;
  final String buildingNumber;
  final String latitude;
  final String longitude;
  final String description;
  final List<String> features;
  final List<String> photos;
  final List<String> proofPhotos;
  final List<PlatformFile> proofDocuments;
  final String ownershipDocumentType;
  final bool? isFurnished;

  final double? price;
  final String priceCurrency;
  final String priceUnit;
  final double? areaSqm;

  final int? rooms;
  final int? bathrooms;
  final int? floorNumber;

  final String? errorMessage;
  final CreatePropertyStatus status;
  final bool isLoading;

  const CreatePropertyState({
    this.listingType = '',
    this.type = '',
    this.customType,
    this.city = '',
    this.district = '',
    this.buildingNumber = '',
    this.latitude = '',
    this.longitude = '',
    this.description = '',
    this.features = const [],
    this.photos = const [],
    this.proofPhotos = const [],
    this.proofDocuments = const [],
    this.ownershipDocumentType = '',
    this.isFurnished,
    this.price,
    this.priceCurrency = 'JOD',
    this.priceUnit = '',
    this.areaSqm,
    this.rooms = 0,
    this.bathrooms = 0,
    this.floorNumber,
    this.errorMessage,
    this.status = CreatePropertyStatus.initial,
    this.isLoading = false,
  });

  CreatePropertyState copyWith({
    String? listingType,
    String? type,
    String? customType,
    String? city,
    String? district,
    String? buildingNumber,
    String? latitude,
    String? longitude,
    String? description,
    List<String>? features,
    List<String>? photos,
    List<String>? proofPhotos,
    List<PlatformFile>? proofDocuments,
    String? ownershipDocumentType,
    bool? isFurnished,
    double? price,
    String? priceCurrency,
    String? priceUnit,
    double? areaSqm,
    int? rooms,
    int? bathrooms,
    int? floorNumber,
    String? errorMessage,
    CreatePropertyStatus? status,
    bool? isLoading,
  }) {
    return CreatePropertyState(
      listingType: listingType ?? this.listingType,
      type: type ?? this.type,
      customType: customType ?? this.customType,
      city: city ?? this.city,
      district: district ?? this.district,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      features: features ?? this.features,
      photos: photos ?? this.photos,
      proofPhotos: proofPhotos ?? this.proofPhotos,
      proofDocuments: proofDocuments ?? this.proofDocuments,
      ownershipDocumentType:
          ownershipDocumentType ?? this.ownershipDocumentType,
      isFurnished: isFurnished ?? this.isFurnished,
      price: price ?? this.price,
      priceCurrency: priceCurrency ?? this.priceCurrency,
      priceUnit: priceUnit ?? this.priceUnit,
      areaSqm: areaSqm ?? this.areaSqm,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      floorNumber: floorNumber ?? this.floorNumber,
      errorMessage: errorMessage,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
