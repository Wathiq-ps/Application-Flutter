import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import 'app_svg_button.dart';

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
    this.switchIconText = false,
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
  final bool switchIconText;

  @override
  Widget build(BuildContext context) {
    final Widget textWidget = Text(
      label,
      style: TextStyle(
        color: color ?? AppColors.textPrimary,
        fontSize: fontSize * widthScale,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );

    final Widget iconWidget = AppSvgIconButton(
      widthScale: widthScale,
      icon: icon,
      iconWidth: iconWidth,
      iconHeight: iconHeight,
      boxSize: 12,
      color: iconColor,
      onTap: onTap,
    );

    final Widget gapWidget = SizedBox(width: gap * widthScale);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: switchIconText
            ? [iconWidget, gapWidget, textWidget]
            : [textWidget, gapWidget, iconWidget],
      ),
    );
  }
}