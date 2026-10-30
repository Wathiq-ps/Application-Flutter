import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/extensions/media_query_extensions.dart';

class RequirementItem extends StatelessWidget {
  const RequirementItem({
    super.key,
    required this.text,
    this.circleOpacity = 0.07,
  });

  final String text;

  /// Figma uses 0.07 on step 1 and 0.17 on step 2.
  final double circleOpacity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;

    return Row(
      children: [
        Container(
          width: 24 * widthScale,
          height: 24 * widthScale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white.withValues(alpha: circleOpacity),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.check_rounded,
            color: AppColors.white,
            size: 12 * widthScale,
          ),
        ),
        SizedBox(width: 12 * widthScale),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.white,
              fontSize: 16 * widthScale,
              height: 24 / 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}