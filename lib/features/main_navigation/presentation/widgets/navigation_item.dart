import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    super.key,
    required this.isSelected,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    required this.scale,
    required this.onTap,
  });

  final bool isSelected;
  final String selectedIcon;
  final String unselectedIcon;
  final String label;
  final double scale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSize = 18 * scale;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        height: isSelected
            ? (34 * scale).clamp(30.0, 80.0)
            : (24 * scale).clamp(20.0, 28.0),
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 * scale : 0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: SvgPicture.asset(
                isSelected ? selectedIcon : unselectedIcon,
                key: ValueKey(isSelected),
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : AppColors.white,
                  BlendMode.srcIn,
                ),
                excludeFromSemantics: true,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              child: isSelected
                  ? Padding(
                padding: EdgeInsets.only(left: 8 * scale),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontSize: (14 * scale).clamp(11.0, 14.0),
                    fontWeight: FontWeight.w700,
                    height: 20 / 14,
                    letterSpacing: 0.14,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}