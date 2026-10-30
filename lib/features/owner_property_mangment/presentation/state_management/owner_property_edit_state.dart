import 'package:equatable/equatable.dart';
import '../../domain/entities/owner_property_list_item.dart';

enum OwnerPropertySaveStatus { idle, saving, success, error }

class OwnerPropertyEditState extends Equatable {
  const OwnerPropertyEditState({
    required this.property,
    this.saveStatus = OwnerPropertySaveStatus.idle,
    this.errorMessage,
    this.sentToReview = false,
    this.toggleStatus = OwnerPropertySaveStatus.idle,
    this.toggleMessage,
    this.listingToggled = false,
  });

  final OwnerPropertyListItem property;
  final OwnerPropertySaveStatus saveStatus;
  final String? errorMessage;
  final bool sentToReview;
  final OwnerPropertySaveStatus toggleStatus;
  final String? toggleMessage;
  final bool listingToggled;

  OwnerPropertyEditState copyWith({
    OwnerPropertyListItem? property,
    OwnerPropertySaveStatus? saveStatus,
    String? errorMessage,
    bool? sentToReview,
    bool clearError = false,
    OwnerPropertySaveStatus? toggleStatus,
    String? toggleMessage,
    bool clearToggleMessage = false,
    bool? listingToggled,
  }) {
    return OwnerPropertyEditState(
      property: property ?? this.property,
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sentToReview: sentToReview ?? this.sentToReview,
      toggleStatus: toggleStatus ?? this.toggleStatus,
      toggleMessage:
      clearToggleMessage ? null : (toggleMessage ?? this.toggleMessage),
      listingToggled: listingToggled ?? this.listingToggled,
    );
  }

  @override
  List<Object?> get props => [
    property,
    saveStatus,
    errorMessage,
    sentToReview,
    toggleStatus,
    toggleMessage,
    listingToggled,
  ];
}