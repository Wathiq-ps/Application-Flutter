import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/error/api_exception.dart';
import '../../../../core/constant/strings.dart';
import '../../domain/entities/owner_property_list_item.dart';
import '../../domain/entities/property_status.dart';
import '../../domain/repositories/owner_property_repository.dart';
import 'owner_property_edit_state.dart';

class OwnerPropertyEditCubit extends Cubit<OwnerPropertyEditState> {
  OwnerPropertyEditCubit({
    required OwnerPropertyListItem property,
    required OwnerPropertyRepository repository,
  })  : _repository = repository,
        _original = property,
        super(OwnerPropertyEditState(property: property));

  final OwnerPropertyRepository _repository;
  OwnerPropertyListItem _original;

  void toggleListingActive() =>
      _update((p) => p.copyWith(isListingActive: !p.isListingActive));

  void updatePropertyType(String value) =>
      _update((p) => p.copyWith(propertyType: value));

  void updatePrice(String value) => _update((p) => p.copyWith(price: value));

  void updateListingType(String value) =>
      _update((p) => p.copyWith(listingType: value));

  void updateRentUnit(String apiValue) =>
      _update((p) => p.copyWith(rentUnit: apiValue));

  void updateCurrency(String value) =>
      _update((p) => p.copyWith(currency: value));

  void updateArea(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) return;
    _update((p) => p.copyWith(areaSqm: parsed.toInt()));
  }

  void updateRooms(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return;
    _update((p) => p.copyWith(rooms: parsed));
  }

  void updateBathrooms(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return;
    _update((p) => p.copyWith(bathrooms: parsed));
  }

  void updateFloor(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) return;
    _update((p) => p.copyWith(floorNumber: parsed));
  }

  void updateFurnished(bool value) =>
      _update((p) => p.copyWith(isFurnished: value));

  void updateFeatures(List<String> value) =>
      _update((p) => p.copyWith(features: value));

  void updateDescription(String value) =>
      _update((p) => p.copyWith(description: value));

  void _update(OwnerPropertyListItem Function(OwnerPropertyListItem) transform) {
    emit(state.copyWith(property: transform(state.property)));
  }

  bool get _needsAdminReview {
    final current = state.property;
    return current.areaSqm != _original.areaSqm ||
        current.propertyType.trim().toLowerCase() !=
            _original.propertyType.trim().toLowerCase();
  }

  Future<void> save() async {
    final property = state.property;

    if (property.listingType == 'rent' && property.rentUnit == null) {
      emit(state.copyWith(
        saveStatus: OwnerPropertySaveStatus.error,
        errorMessage: AppStrings.priceUnitRequiredForRent,
        sentToReview: false,
      ));
      return;
    }

    final bool needsReview = _needsAdminReview;

    emit(state.copyWith(
      saveStatus: OwnerPropertySaveStatus.saving,
      sentToReview: false,
      clearError: true,
    ));

    try {
      var updated = await _repository.updateProperty(property);
      if (isClosed) return;

      if (needsReview) {
        updated = updated.copyWith(status: PropertyStatus.review);
      }
      _original = updated;

      emit(state.copyWith(
        property: updated,
        saveStatus: OwnerPropertySaveStatus.success,
        sentToReview: needsReview,
      ));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: OwnerPropertySaveStatus.error,
        errorMessage: e.message,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: OwnerPropertySaveStatus.error,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  Future<void> delete() async {
    emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.saving, clearError: true));
    try {
      await _repository.deleteProperty(state.property.id);
      if (isClosed) return;
      emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.success));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: OwnerPropertySaveStatus.error,
        errorMessage: e.message,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: OwnerPropertySaveStatus.error,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  void resetSaveStatus() =>
      emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.idle));
}