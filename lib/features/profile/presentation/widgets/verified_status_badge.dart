import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app_icons.dart';
import '../../../../core/extensions/media_query_extensions.dart';

class VerifiedStatusBadge extends StatelessWidget {
  final bool isVerified;

  const VerifiedStatusBadge({
    super.key,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    final double widthScale = context.screenWidth / 393;

    const Color verifiedColor = Color(0xFF007146);
    const Color notVerifiedColor = Color(0xFFB3261E);

    final Color statusColor =
    isVerified ? verifiedColor : notVerifiedColor;

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 6 * widthScale,
          horizontal: 14 * widthScale,
        ),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isVerified
                  ? AppIcons.verified_profile_status
                  : AppIcons.verified_profile_status,
              width: 16 * widthScale,
              height: 16 * widthScale,
              colorFilter: ColorFilter.mode(
                statusColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6 * widthScale),
            Text(
              isVerified ? 'Verified ID' : 'Not Verified ID',
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