import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';


class AppSectionRow extends StatelessWidget {
  const AppSectionRow({
    super.key,
    required this.widthScale,
    required this.label,
    this.trailing,
    this.showTrailing = true,
    this.fontSize = 11,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.lineHeight = 14 / 11,
    this.letterSpacing = 0.44,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textStyle,
    this.expandLabel = true,
    this.gap = 8,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = EdgeInsets.zero,
    this.onLabelTap,
  });

  final double widthScale;
  final String label;
  final Widget? trailing;
  final bool showTrailing;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final double lineHeight;
  final double letterSpacing;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final TextStyle? textStyle;
  final bool expandLabel;
  final double gap;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry padding;

  final VoidCallback? onLabelTap;

  TextStyle get _resolvedStyle {
    final TextStyle base = TextStyle(
      color: color ?? AppColors.textPrimary,
      fontSize: fontSize * widthScale,
      fontWeight: fontWeight,
      height: lineHeight,
      letterSpacing: letterSpacing,
    );
    return textStyle == null ? base : base.merge(textStyle);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasTrailing = showTrailing && trailing != null;

    Widget labelWidget = Text(
      label,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _resolvedStyle,
    );

    if (onLabelTap != null) {
      labelWidget = GestureDetector(
        onTap: onLabelTap,
        behavior: HitTestBehavior.opaque,
        child: labelWidget,
      );
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (expandLabel) Flexible(child: labelWidget) else labelWidget,
          if (hasTrailing) ...[
            if (gap > 0) SizedBox(width: gap * widthScale),
            trailing!,
          ],
        ],
      ),
    );
  }
}