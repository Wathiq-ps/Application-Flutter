import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';

class PropertySpecChip extends StatelessWidget {
  const PropertySpecChip({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.widthScale,
  });

  final String iconAsset;
  final String label;
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  85 * widthScale,
      height: 32 * widthScale,
      padding: EdgeInsets.symmetric(
        horizontal: 10 * widthScale,
        vertical: 4 * widthScale,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8 * widthScale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 14 * widthScale,
            height: 14 * widthScale,
            colorFilter: ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4 * widthScale),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11 * widthScale,
              fontWeight: FontWeight.w600,
              height: 14 / 11,
              letterSpacing: 0.44,
            ),
          ),
        ],
      ),
    );
  }
}