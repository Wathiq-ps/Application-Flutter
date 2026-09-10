import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class PromoIndicator extends StatelessWidget {
  const PromoIndicator({
    super.key,
    required this.width,
    required this.widthScale,
    this.opacity = 1,
  });

  final double width;
  final double widthScale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6 * widthScale,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(9999),
      ),
    );
  }
}