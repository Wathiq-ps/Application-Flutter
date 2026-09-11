

import 'package:equatable/equatable.dart';

import '../../domain/entities/property_status.dart';

class OwnerPropertyListItem extends Equatable {
  const OwnerPropertyListItem({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.rooms,
    required this.bathrooms,
    required this.areaSqm,
    required this.price,
    required this.priceUnit,
    required this.status,
    this.isListingActive = true,
  });

  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final int rooms;
  final int bathrooms;
  final int areaSqm;
  final String price;
  final String priceUnit;
  final PropertyStatus status;
  final bool isListingActive;

  OwnerPropertyListItem copyWith({
    bool? isListingActive,
  }) {
    return OwnerPropertyListItem(
      id: id,
      title: title,
      location: location,
      imageUrl: imageUrl,
      rooms: rooms,
      bathrooms: bathrooms,
      areaSqm: areaSqm,
      price: price,
      priceUnit: priceUnit,
      status: status,
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
    status,
    isListingActive,
  ];
}

enum OwnerPropertySaveStatus { idle, saving, success, error }

class OwnerPropertyState extends Equatable {
  const OwnerPropertyState({
    this.properties = const [],
    this.showStatusBadge = true,
    this.saveStatus = OwnerPropertySaveStatus.idle,
    this.errorMessage,
  });

  final List<OwnerPropertyListItem> properties;
  final bool showStatusBadge;
  final OwnerPropertySaveStatus saveStatus;
  final String? errorMessage;

  OwnerPropertyState copyWith({
    List<OwnerPropertyListItem>? properties,
    bool? showStatusBadge,
    OwnerPropertySaveStatus? saveStatus,
    String? errorMessage,
  }) {
    return OwnerPropertyState(
      properties: properties ?? this.properties,
      showStatusBadge: showStatusBadge ?? this.showStatusBadge,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    properties,
    showStatusBadge,
    saveStatus,
    errorMessage,
  ];
}