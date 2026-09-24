import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';

class PromoIndicator extends StatelessWidget {
  const PromoIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.widthScale,
  });

  final int count;
  final int currentIndex;
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: EdgeInsets.symmetric(horizontal: 3 * widthScale),
          height: 6 * widthScale,
          width: (active ? 22 : 6) * widthScale,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(3 * widthScale),
          ),
        );
      }),
    );
  }
}