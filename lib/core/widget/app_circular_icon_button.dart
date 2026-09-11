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

  /// SVG icon displayed inside the button.
  final String icon;

  /// Whether the button is currently selected.
  ///
  /// Example:
  /// - Favorite = true
  /// - Not favorite = false
  final bool isSelected;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Button size.
  ///
  /// Figma default: 36 x 36.
  final double size;

  /// SVG icon width.
  ///
  /// Figma default: 18.
  final double iconWidth;

  /// SVG icon height.
  ///
  /// Figma default: 16.
  final double iconHeight;

  /// Background color shown when selected.
  ///
  /// Figma default: #B5C4FF.
  final Color selectedBackgroundColor;

  /// Background opacity shown when selected.
  ///
  /// Figma default: 50%.
  final double selectedBackgroundOpacity;

  /// Backdrop blur amount.
  ///
  /// Figma default: 6px.
  final double blur;

  /// Border radius.
  ///
  /// Defaults to a fully circular shape.
  final double? borderRadius;

  /// Shadow color.
  ///
  /// Figma default: black.
  final Color shadowColor;

  /// Shadow opacity.
  ///
  /// Figma default: 5%.
  final double shadowOpacity;

  /// Shadow offset.
  ///
  /// Figma default: 0px 1px.
  final Offset shadowOffset;

  /// Shadow blur radius.
  ///
  /// Figma default: 2px.
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
