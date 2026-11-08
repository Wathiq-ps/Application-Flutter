import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../domain/entities/profile_entity.dart';

class VerifiedStatusBadge extends StatelessWidget {
  final ProfileIdentityStatus status;
  final bool isProfileComplete;
  final double widthScale;

  const VerifiedStatusBadge({
    super.key,
    required this.status,
    required this.isProfileComplete,
    required this.widthScale,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVerified =
        isProfileComplete && status == ProfileIdentityStatus.approved;
    final Color statusColor = isVerified
        ? AppColors.verifiedStatusText
        : AppColors.unverifiedStatusText;

    final Color statusBg = isVerified
        ? AppColors.verifiedStatusBg
        : AppColors.unverifiedStatusBg;

    final String icon = isVerified
        ? AppIcons.verified_profile_status
        : AppIcons.unVerified_profile_status;
    final String label = !isProfileComplete
        ? AppStrings.completeYourProfile
        : switch (status) {
            ProfileIdentityStatus.pending => AppStrings.notVerifiedID,
            ProfileIdentityStatus.underReview => AppStrings.identityUnderReview,
            ProfileIdentityStatus.approved => AppStrings.verifiedID,
            ProfileIdentityStatus.rejected => AppStrings.verificationRejected,
          };

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
              icon,
              width: 16 * widthScale,
              height: 16 * widthScale,
              colorFilter: ColorFilter.mode(statusColor, BlendMode.srcIn),
            ),
            SizedBox(width: 6 * widthScale),
            Text(
              label,
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
