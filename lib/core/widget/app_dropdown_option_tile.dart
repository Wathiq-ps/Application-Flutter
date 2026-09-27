import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';


class AppDropdownOptionTile extends StatelessWidget {
  const AppDropdownOptionTile({
    super.key,
    required this.widthScale,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.fontSize = 14,
    this.selectedFontWeight = FontWeight.w700,
    this.unselectedFontWeight = FontWeight.w400,
    this.selectedColor,
    this.unselectedColor,
    this.checkIcon = Icons.check_rounded,
    this.checkIconSize = 18,
    this.horizontalPadding = 4,
    this.verticalPadding = 12,
    this.borderRadius = 10,
  });

  final double widthScale;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  final double fontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final Color? selectedColor;
  final Color? unselectedColor;

  final IconData checkIcon;
  final double checkIconSize;

  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final double ws = widthScale;
    final Color resolvedSelectedColor = selectedColor ?? AppColors.primary;
    final Color resolvedUnselectedColor =
        unselectedColor ?? AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius * ws),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * ws,
          vertical: verticalPadding * ws,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize * ws,
                  fontWeight: isSelected
                      ? selectedFontWeight
                      : unselectedFontWeight,
                  color: isSelected
                      ? resolvedSelectedColor
                      : resolvedUnselectedColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                checkIcon,
                size: checkIconSize * ws,
                color: resolvedSelectedColor,
              ),
          ],
        ),
      ),
    );
  }
}