import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgIconButton extends StatelessWidget {
  const AppSvgIconButton({
    super.key,
    required this.widthScale,
    required this.icon,
    this.onTap,
    this.boxSize = 24,
    this.iconWidth,
    this.iconHeight,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.semanticLabel,
  });

  final double widthScale;
  final String icon;
  final VoidCallback? onTap;
  final double boxSize;
  final double? iconWidth;
  final double? iconHeight;
  final Color? color;
  final Color? backgroundColor;
  final double? borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: boxSize * widthScale,
        height: boxSize * widthScale,
        decoration: backgroundColor == null
            ? null
            : BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            (borderRadius ?? boxSize / 2) * widthScale,
          ),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          icon,
          width: (iconWidth ?? boxSize) * widthScale,
          height: (iconHeight ?? boxSize) * widthScale,
          fit: BoxFit.contain,
          semanticsLabel: semanticLabel,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
        ),
      ),
    );
  }
}