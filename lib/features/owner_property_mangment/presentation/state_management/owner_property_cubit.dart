import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/property_status.dart';
import 'owner_property_state.dart';

class OwnerPropertyCubit extends Cubit<OwnerPropertyState> {
  OwnerPropertyCubit() : super(const OwnerPropertyState()) {
    _loadMockProperties();
  }

  // TODO: replace with a real repository call.
  void _loadMockProperties() {
    emit(
      state.copyWith(
        properties: const [
          OwnerPropertyListItem(
            id: '1',
            title: 'Modern Apartment — 3 Rooms',
            location: 'Gaza',
            imageUrl: '',
            rooms: 3,
            bathrooms: 2,
            areaSqm: 165,
            price: '5,000',
            priceUnit: 'JOD / week',
            status: PropertyStatus.active,
          ),
          OwnerPropertyListItem(
            id: '2',
            title: 'Modern Apartment — 3 Rooms',
            location: 'Gaza',
            imageUrl: '',
            rooms: 3,
            bathrooms: 2,
            areaSqm: 165,
            price: '100',
            priceUnit: 'JOD / hour',
            status: PropertyStatus.review,
          ),
        ],
      ),
    );
  }

  /// Toggles whether the status badge is visible on property cards.
  void toggleStatusVisibility() {
    emit(state.copyWith(showStatusBadge: !state.showStatusBadge));
  }

  /// Toggles a single property's active/inactive listing switch
  /// (the Edit Property screen's status toggle).
  void toggleListingActive(String propertyId) {
    final updated = state.properties.map((property) {
      if (property.id != propertyId) return property;
      return property.copyWith(isListingActive: !property.isListingActive);
    }).toList();

    emit(state.copyWith(properties: updated));
  }

  Future<void> saveProperty(String propertyId) async {
    emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.saving));

    // TODO: replace with a real save call.
    await Future.delayed(const Duration(milliseconds: 900));

    emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.success));
  }

  Future<void> deleteProperty(String propertyId) async {
    emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.saving));

    // TODO: replace with a real delete call.
    await Future.delayed(const Duration(milliseconds: 900));

    final updated =
    state.properties.where((p) => p.id != propertyId).toList();

    emit(
      state.copyWith(
        properties: updated,
        saveStatus: OwnerPropertySaveStatus.success,
      ),
    );
  }

  void resetSaveStatus() {
    emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.idle));
  }
}