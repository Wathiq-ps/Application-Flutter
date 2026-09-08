import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';
export 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void changeTab(int index) {
    if (state.selectedIndex == index) return;
    emit(state.copyWith(selectedIndex: index));
  }
}