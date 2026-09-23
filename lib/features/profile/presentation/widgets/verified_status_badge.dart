import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';

class VerifiedStatusBadge extends StatelessWidget {
  final bool isVerified;
  final double widthScale;

  const VerifiedStatusBadge({
    super.key,
    required this.isVerified,
    required this.widthScale,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isVerified
        ? AppColors.verifiedStatusText
        : AppColors.unverifiedStatusText;

    final Color statusBg = isVerified
        ? AppColors.verifiedStatusBg
        : AppColors.unverifiedStatusBg;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 6 * widthScale,
          horizontal: 14 * widthScale,
        ),
        decoration: BoxDecoration(
          color: statusBg,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.verified_profile_status,
              width: 16 * widthScale,
              height: 16 * widthScale,
              colorFilter: ColorFilter.mode(
                statusColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6 * widthScale),
            Text(
              isVerified ? AppStrings.verifiedID : AppStrings.notVerifiedID,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: statusColor,
                fontSize: 13 * widthScale,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}