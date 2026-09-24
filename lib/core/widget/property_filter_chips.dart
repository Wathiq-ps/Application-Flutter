import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../constant/strings.dart';

class PropertyFilterChips extends StatelessWidget {
  const PropertyFilterChips({
    super.key,
    required this.widthScale,
    this.selectedIndex,
    this.onChanged,
    this.labels = const [
      AppStrings.forSale,
      AppStrings.forRent,
    ],
    this.allowDeselect = true,
  });

  final double widthScale;
  final int? selectedIndex;
  final ValueChanged<int?>? onChanged;
  final List<String> labels;
  final bool allowDeselect;

  void _handleTap(int index) {
    final bool isSelected = index == selectedIndex;
    if (isSelected && !allowDeselect) return;
    onChanged?.call(isSelected ? null : index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44 * widthScale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: labels.length,
        separatorBuilder: (_, __) => SizedBox(width: 7 * widthScale),
        itemBuilder: (context, index) {
          final bool selected = index == selectedIndex;

          return GestureDetector(
            onTap: () => _handleTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 36 * widthScale,
              padding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: selected
                      ? AppColors.white
                      : AppColors.filterChipUnselectedBorderColor,
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                labels[index],
                style: TextStyle(
                  color: selected ? AppColors.white : AppColors.primary,
                  fontSize: 12 * widthScale,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  height: 16 / 12,
                  letterSpacing: 0.24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}