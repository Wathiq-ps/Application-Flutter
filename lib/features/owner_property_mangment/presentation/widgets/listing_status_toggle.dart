import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class ListingStatusToggle extends StatelessWidget {
  const ListingStatusToggle({
    super.key,
    required this.isActive,
    required this.widthScale,
    this.onChanged,
  });

  final bool isActive;
  final double widthScale;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final double trackWidth = 70 * widthScale;
    final double trackHeight = 22 * widthScale;
    final double knobWidth = 41 * widthScale;

    return GestureDetector(
      onTap: () => onChanged?.call(!isActive),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: trackWidth,
        height: trackHeight,
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : AppColors.primary,
          borderRadius: BorderRadius.circular(22 * widthScale),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.25),
              blurRadius: 4 * widthScale,
            ),
          ]
              : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment:
          isActive ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: knobWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF006D43)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(22 * widthScale),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.25),
                  blurRadius: 4 * widthScale,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}