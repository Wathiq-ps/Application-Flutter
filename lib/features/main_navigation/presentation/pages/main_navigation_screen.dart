import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/fade_indexed_stack.dart';
import '../state_mangment/navigation_cubit.dart';
import '../widgets/main_bottom_navigation_bar.dart';
import '../widgets/navigation_placeholder.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> pages = [
    NavigationPlaceholder(title: AppStrings.home),
    NavigationPlaceholder(title: AppStrings.search),
    NavigationPlaceholder(title: AppStrings.favourite),
    NavigationPlaceholder(title: AppStrings.profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: false,
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) => FadeIndexedStack(
          index: state.selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) => MainBottomNavigationBar(
          selectedIndex: state.selectedIndex,
          onTabSelected: context.read<NavigationCubit>().changeTab,
        ),
      ),
    );
  }
}