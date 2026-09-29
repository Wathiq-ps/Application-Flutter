import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/error/api_exception.dart';
import '../../../../core/constant/strings.dart';
import '../../domain/entities/owner_property_list_item.dart';
import '../../domain/repositories/owner_property_repository.dart';
import 'owner_property_edit_state.dart';

class OwnerPropertyEditCubit extends Cubit<OwnerPropertyEditState> {
  OwnerPropertyEditCubit({
    required OwnerPropertyListItem property,
    required OwnerPropertyRepository repository,
  })  : _repository = repository,
        super(OwnerPropertyEditState(property: property));

  final OwnerPropertyRepository _repository;

  void toggleListingActive() =>
      _update((p) => p.copyWith(isListingActive: !p.isListingActive));

  void updatePropertyType(String value) => _update((p) => p.copyWith(propertyType: value));

  void updatePrice(String value) => _update((p) => p.copyWith(price: value));

  void updateListingType(String value) => _update((p) => p.copyWith(listingType: value));

  void updateCurrency(String value) => _update((p) => p.copyWith(currency: value));

  void updateArea(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) return;
    _update((p) => p.copyWith(areaSqm: parsed.toInt()));
  }

  void updateFeatures(String value) {
    final roomsExp = RegExp(r'(\d+)\s*Rooms', caseSensitive: false);
    final bathsExp = RegExp(r'(\d+)\s*Bathrooms', caseSensitive: false);
    final rooms = int.tryParse(roomsExp.firstMatch(value)?.group(1) ?? '');
    final baths = int.tryParse(bathsExp.firstMatch(value)?.group(1) ?? '');
    _update((p) => p.copyWith(rooms: rooms ?? p.rooms, bathrooms: baths ?? p.bathrooms));
  }

  void updateDescription(String value) => _update((p) => p.copyWith(description: value));

  void _update(OwnerPropertyListItem Function(OwnerPropertyListItem) transform) {
    emit(state.copyWith(property: transform(state.property)));
  }

  Future<void> save() async {
    emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.saving, clearError: true));
    try {
      final updated = await _repository.updateProperty(state.property);
      if (isClosed) return;
      emit(state.copyWith(property: updated, saveStatus: OwnerPropertySaveStatus.success));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.error, errorMessage: e.message));
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
      emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.error, errorMessage: e.message));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        saveStatus: OwnerPropertySaveStatus.error,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  void resetSaveStatus() => emit(state.copyWith(saveStatus: OwnerPropertySaveStatus.idle));
}