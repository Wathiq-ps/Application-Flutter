import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/widget/app_svg_button.dart';

class AppLabelIconTrigger extends StatelessWidget {
  const AppLabelIconTrigger({
    super.key,
    required this.widthScale,
    required this.label,
    required this.icon,
    this.onTap,
    this.fontSize = 8,
    this.color,
    this.fontWeight = FontWeight.w400,
    this.letterSpacing = 0.44,
    this.gap = 4,
    this.iconWidth = 7,
    this.iconHeight = 5,
    this.iconColor,
  });

  final double widthScale;
  final String label;
  final String icon;
  final VoidCallback? onTap;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final double letterSpacing;
  final double gap;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: fontSize * widthScale,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            ),
          ),
          SizedBox(width: gap * widthScale),
          AppSvgIconButton(
            widthScale: widthScale,
            icon: icon,
            iconWidth: iconWidth,
            iconHeight: iconHeight,
            boxSize: 12,
            color: iconColor,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}