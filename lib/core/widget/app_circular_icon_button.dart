import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/app_colors.dart';

class AppCircularIconButton extends StatelessWidget {
  const AppCircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
    this.size = 36,
    this.iconWidth = 18,
    this.iconHeight = 16,
    this.selectedBackgroundColor = const Color(0xFFB5C4FF),
    this.selectedBackgroundOpacity = 0.5,
    this.blur = 6,
    this.borderRadius,
    this.shadowColor = AppColors.black,
    this.shadowOpacity = 0.05,
    this.shadowOffset = const Offset(0, 1),
    this.shadowBlurRadius = 2,
  });


  final String icon;
  final bool isSelected;
  final VoidCallback? onPressed;
  final double size;
  final double iconWidth;
  final double iconHeight;
  final Color selectedBackgroundColor;
  final double selectedBackgroundOpacity;
  final double blur;
  final double? borderRadius;
  final Color shadowColor;
  final double shadowOpacity;
  final Offset shadowOffset;
  final double shadowBlurRadius;

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? size / 2;

    final bool showBackground = isSelected;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: showBackground ? blur : 0,
          sigmaY: showBackground ? blur : 0,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: showBackground
                ? selectedBackgroundColor.withValues(
              alpha: selectedBackgroundOpacity,
            )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: showBackground
                ? [
              BoxShadow(
                color: shadowColor.withValues(
                  alpha: shadowOpacity,
                ),
                offset: shadowOffset,
                blurRadius: shadowBlurRadius,
              ),
            ]
                : const [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(radius),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  width: iconWidth,
                  height: iconHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
