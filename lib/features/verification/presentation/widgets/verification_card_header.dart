import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/extensions/media_query_extensions.dart';

/// Title + subtitle shown at the top of the glass card.
class VerificationCardHeader extends StatelessWidget {
  const VerificationCardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleFontSize = 28,
    this.titleLineHeight = 38,
    this.titleFontWeight = FontWeight.w500,
    this.titleLetterSpacing = -0.3,
  });

  final String title;
  final String subtitle;
  final double titleFontSize;
  final double titleLineHeight;
  final FontWeight titleFontWeight;
  final double titleLetterSpacing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge?.copyWith(
            color: AppColors.white,
            fontSize: titleFontSize * widthScale,
            height: titleLineHeight / titleFontSize,
            fontWeight: titleFontWeight,
            letterSpacing: titleLetterSpacing,
          ),
        ),
        SizedBox(height: 4 * widthScale),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.white,
            fontSize: 16 * widthScale,
            height: 24 / 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}