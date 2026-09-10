import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';
import '../constant/app_icons.dart';
import '../constant/strings.dart';

class PageSearchBar extends StatelessWidget {
  const PageSearchBar({
    super.key,
    required this.widthScale,
    this.onTap,
  });

  final double widthScale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50 * widthScale,
        padding: EdgeInsets.symmetric(
          horizontal: 16 * widthScale,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppIcons.searchUnselected,
              width: 18 * widthScale,
              height: 18 * widthScale,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 5 * widthScale),
            Expanded(
              child: Text(
                AppStrings.searchByLocation,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14 * widthScale,
                  fontWeight: FontWeight.w400,
                  height: 17 / 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}