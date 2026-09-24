// class NavigationState {
//   const NavigationState({this.selectedIndex = 0});
//
//   final int selectedIndex;
//
//   NavigationState copyWith({int? selectedIndex}) {
//     return NavigationState(
//       selectedIndex: selectedIndex ?? this.selectedIndex,
//     );
//   }
// }

import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int selectedIndex;

  final int searchFocusRequestId;
  const NavigationState({this.selectedIndex = 0, this.searchFocusRequestId = 0});

  NavigationState copyWith({int? selectedIndex, int? searchFocusRequestId}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      searchFocusRequestId: searchFocusRequestId ?? this.searchFocusRequestId,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, searchFocusRequestId];
}