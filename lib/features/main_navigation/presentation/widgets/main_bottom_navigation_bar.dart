import 'package:flutter/material.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import 'navigation_item.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    const figmaWidth = 394.0;
    final scale = screenWidth / figmaWidth;
    final navigationHeight = (62 * scale).clamp(56.0, 140.0);

    return Container(
      height: navigationHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            blurRadius: 45.6,
            spreadRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 34 * scale, vertical: 14 * scale),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavigationItem(
                isSelected: selectedIndex == 0,
                selectedIcon: AppIcons.houseSelected,
                unselectedIcon: AppIcons.houseUnSelected,
                label: AppStrings.home,
                scale: scale,
                onTap: () => onTabSelected(0),
              ),
              NavigationItem(
                isSelected: selectedIndex == 1,
                selectedIcon: AppIcons.searchSelected,
                unselectedIcon: AppIcons.searchUnselected,
                label: AppStrings.search,
                scale: scale,
                onTap: () => onTabSelected(1),
              ),
              NavigationItem(
                isSelected: selectedIndex == 2,
                selectedIcon: AppIcons.favouriteSelected,
                unselectedIcon: AppIcons.favouriteUnselected,
                label: AppStrings.favourite,
                scale: scale,
                onTap: () => onTabSelected(2),
              ),
              NavigationItem(
                isSelected: selectedIndex == 3,
                selectedIcon: AppIcons.personSelected,
                unselectedIcon: AppIcons.personUnselected,
                label: AppStrings.profile,
                scale: scale,
                onTap: () => onTabSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}