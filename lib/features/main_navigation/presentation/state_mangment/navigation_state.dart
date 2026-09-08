class NavigationState {
  const NavigationState({this.selectedIndex = 0});

  final int selectedIndex;

  NavigationState copyWith({int? selectedIndex}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}