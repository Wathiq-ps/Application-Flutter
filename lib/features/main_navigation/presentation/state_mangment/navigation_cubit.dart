// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'navigation_state.dart';
// export 'navigation_state.dart';
//
// class NavigationCubit extends Cubit<NavigationState> {
//   NavigationCubit() : super(const NavigationState());
//
//   void changeTab(int index) {
//     if (state.selectedIndex == index) return;
//     emit(state.copyWith(selectedIndex: index));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';
import 'navigation_tab.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void changeTab(int index) {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(selectedIndex: index));
  }

  void goToSearch({bool focusSearchField = false}) {
    emit(state.copyWith(
      selectedIndex: AppTab.search.index,
      searchFocusRequestId:
      focusSearchField ? state.searchFocusRequestId + 1 : null,
    ));
  }
}