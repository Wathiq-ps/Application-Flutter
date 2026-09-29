import 'package:equatable/equatable.dart';
import '../../domain/entities/owner_property_list_item.dart';

enum OwnerPropertySaveStatus { idle, saving, success, error }

class OwnerPropertyEditState extends Equatable {
  const OwnerPropertyEditState({
    required this.property,
    this.saveStatus = OwnerPropertySaveStatus.idle,
    this.errorMessage,
  });

  final OwnerPropertyListItem property;
  final OwnerPropertySaveStatus saveStatus;
  final String? errorMessage;

  OwnerPropertyEditState copyWith({
    OwnerPropertyListItem? property,
    OwnerPropertySaveStatus? saveStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OwnerPropertyEditState(
      property: property ?? this.property,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [property, saveStatus, errorMessage];
}