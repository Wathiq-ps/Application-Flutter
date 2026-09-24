import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/owner_property_list_item.dart';
import '../../domain/entities/property_status.dart';
import '../state_management/owner_property_state.dart';

class OwnerPropertyCubit extends Cubit<OwnerPropertyState> {
  /// Used by the owner properties list screen.
  ///
  /// TODO: Replace mock properties with a repository/API call.
  OwnerPropertyCubit()
      : super(
    const OwnerPropertyState(
      properties: [
        OwnerPropertyListItem(
          id: '1',
          title: 'Modern Apartment — 3 Rooms',
          location: 'Gaza',
          rooms: 3,
          bathrooms: 2,
          areaSqm: 165,
          price: '5,000',
          priceUnit: 'JOD /',
          pricePeriod: ' week',
          currency: 'JOD',
          status: PropertyStatus.active,
          propertyType: 'Apartment',
          isListingActive: true,
        ),
        OwnerPropertyListItem(
          id: '2',
          title: 'Modern Apartment — 3 Rooms',
          location: 'Gaza',
          rooms: 3,
          bathrooms: 2,
          areaSqm: 165,
          price: '100',
          priceUnit: 'JOD /',
          pricePeriod: ' hour',
          currency: 'JOD',
          status: PropertyStatus.review,
          propertyType: 'Apartment',
          isListingActive: false,
        ),
      ],
    ),
  );

  /// Used by the edit property screen.
  ///
  /// The Cubit starts with the property selected by the user.
  OwnerPropertyCubit.forEdit({
    required OwnerPropertyListItem property,
  }) : super(
    OwnerPropertyState(
      properties: [property],
    ),
  );

  void toggleListingActive(String propertyId) {
    final updatedProperties = state.properties.map((property) {
      if (property.id != propertyId) {
        return property;
      }

      return property.copyWith(
        isListingActive: !property.isListingActive,
      );
    }).toList();

    emit(
      state.copyWith(
        properties: updatedProperties,
      ),
    );
  }

  void updatePropertyType(
      String propertyId,
      String propertyType,
      ) {
    _updateProperty(
      propertyId,
          (property) => property.copyWith(
        propertyType: propertyType,
      ),
    );
  }

  void updatePrice(
      String propertyId,
      String newPrice,
      ) {
    _updateProperty(
      propertyId,
          (property) => property.copyWith(
        price: newPrice,
      ),
    );
  }

  void updateCurrency(
      String propertyId,
      String newCurrency,
      ) {
    _updateProperty(
      propertyId,
          (property) => property.copyWith(
        currency: newCurrency,
      ),
    );
  }

  void updateArea(
      String propertyId,
      String newArea,
      ) {
    final double? parsedArea = double.tryParse(newArea);

    if (parsedArea == null) {
      return;
    }

    _updateProperty(
      propertyId,
          (property) => property.copyWith(
        areaSqm: parsedArea.toInt(),
      ),
    );
  }

  void updateFeatures(
      String propertyId,
      String newValue,
      ) {
    final RegExp roomsExp = RegExp(
      r'(\d+)\s*Rooms',
      caseSensitive: false,
    );

    final RegExp bathroomsExp = RegExp(
      r'(\d+)\s*Bathrooms',
      caseSensitive: false,
    );

    final int? parsedRooms = int.tryParse(
      roomsExp.firstMatch(newValue)?.group(1) ?? '',
    );

    final int? parsedBathrooms = int.tryParse(
      bathroomsExp.firstMatch(newValue)?.group(1) ?? '',
    );

    _updateProperty(
      propertyId,
          (property) => property.copyWith(
        rooms: parsedRooms ?? property.rooms,
        bathrooms: parsedBathrooms ?? property.bathrooms,
      ),
    );
  }

  void updateDescription(
      String propertyId,
      String newDescription,
      ) {
    _updateProperty(
      propertyId,
          (property) => property.copyWith(
        description: newDescription,
      ),
    );
  }

  void _updateProperty(
      String propertyId,
      OwnerPropertyListItem Function(
          OwnerPropertyListItem property,
          ) transform,
      ) {
    final updatedProperties = state.properties.map((property) {
      if (property.id != propertyId) {
        return property;
      }

      return transform(property);
    }).toList();

    emit(
      state.copyWith(
        properties: updatedProperties,
      ),
    );
  }

  Future<void> saveProperty(String propertyId) async {
    emit(
      state.copyWith(
        saveStatus: OwnerPropertySaveStatus.saving,
      ),
    );

    // TODO: Replace with a real repository/API call.
    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    emit(
      state.copyWith(
        saveStatus: OwnerPropertySaveStatus.success,
      ),
    );
  }

  Future<void> deleteProperty(String propertyId) async {
    emit(
      state.copyWith(
        saveStatus: OwnerPropertySaveStatus.saving,
      ),
    );

    // TODO: Replace with a real repository/API call.
    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    final updatedProperties = state.properties
        .where(
          (property) => property.id != propertyId,
    )
        .toList();

    emit(
      state.copyWith(
        properties: updatedProperties,
        saveStatus: OwnerPropertySaveStatus.success,
      ),
    );
  }

  void resetSaveStatus() {
    emit(
      state.copyWith(
        saveStatus: OwnerPropertySaveStatus.idle,
      ),
    );
  }
}