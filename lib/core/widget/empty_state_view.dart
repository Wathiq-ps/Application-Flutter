import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = AppIcons.block,
    this.widthScale,
  });

  final String title;
  final String? subtitle;
  final String icon;
  final double? widthScale;

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    final double ws = widthScale ?? (context.screenWidth / figmaWidth);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 64 * ws,
        horizontal: 20 * ws,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56 * ws,
            height: 56 * ws,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              icon,
              width: 20 * ws,
              height: 20 * ws,
              colorFilter: ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 16 * ws),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18 * ws,
              fontWeight: FontWeight.w600,
              height: 24 / 18,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4 * ws),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.5),
                fontSize: 10 * ws,
                fontWeight: FontWeight.w400,
                height: 16 / 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}