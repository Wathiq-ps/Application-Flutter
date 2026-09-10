import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';
import '../constant/app_icons.dart';
import '../constant/strings.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.widthScale,
    this.userName = 'Samer',
    this.onNotificationTap,
  });

  final double widthScale;
  final String userName;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
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
            userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 12 * widthScale,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
              letterSpacing: 0.24,
            ),
          ),
        ),

        SizedBox(width: 10 * widthScale),

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
          onTap: onNotificationTap,
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