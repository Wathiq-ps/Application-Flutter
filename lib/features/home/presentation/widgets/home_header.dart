import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.userName = 'Samer',
  });

  final String userName;

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale =
        MediaQuery.sizeOf(context).width / figmaWidth;

    return Row(
      children: [
        // ─────────────────────────────────────
        // Profile
        // ─────────────────────────────────────

        Container(
          width: 36 * widthScale,
          height: 36 * widthScale,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 4 * widthScale,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            userName.isNotEmpty
                ? userName[0].toUpperCase()
                : 'S',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 12 * widthScale,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
              letterSpacing: 0.24,
            ),
          ),
        ),

        SizedBox(
          width: 10 * widthScale,
        ),

        // ─────────────────────────────────────
        // Greeting
        // ─────────────────────────────────────

        Expanded(
          child: Text(
            '${AppStrings.hello}, $userName',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16 * widthScale,
              fontWeight: FontWeight.w500,
              height: 16 / 16,
              letterSpacing: 0.24,
            ),
          ),
        ),

        // ─────────────────────────────────────
        // Notification
        // ─────────────────────────────────────

        GestureDetector(
          onTap: () {
            // TODO: Open notifications.
          },
          child: SizedBox(
            width: 24 * widthScale,
            height: 24 * widthScale,
            child: Center(
              child: SvgPicture.asset(
                AppIcons.notifications,
                width: 16 * widthScale,
                height: 20 * widthScale,
              ),
            ),
          ),
        ),
      ],
    );
  }
}