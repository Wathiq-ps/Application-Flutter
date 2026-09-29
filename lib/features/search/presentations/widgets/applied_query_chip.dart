import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';

class AppliedQueryChip extends StatelessWidget {
  const AppliedQueryChip({
    super.key,
    required this.label,
    required this.widthScale,
    required this.onRemove,
  });

  final String label;
  final double widthScale;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final double ws = widthScale;

    return Container(
      height: 25 * ws,
      padding: EdgeInsets.symmetric(horizontal: 12 * ws, vertical: 4 * ws),
      decoration: BoxDecoration(
        color: const Color(0x80B5C4FF), 
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.location,
            width: 8 * ws,
            height: 10 * ws,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 6 * ws),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200 * ws),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14 * ws,
                fontWeight: FontWeight.w400,
                height: 17 / 14,
              ),
            ),
          ),
          SizedBox(width: 6 * ws),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AppIcons.x,
              width: 7 * ws,
              height: 7 * ws,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}