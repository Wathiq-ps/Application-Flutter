import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Generic section row: a label on the left and any widget on the right.
///
/// Typical use is a count/summary line paired with a filter, sort control or
/// action (e.g. "12 properties listed"  •  "All status ▾").
///
/// The label is fully styleable ([fontSize], [color], [fontWeight], ...) with
/// the app's primary text color as the default. [trailing] accepts any widget
/// and can be hidden with [showTrailing] without removing it from the call site.
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

  /// Responsive scale factor used across the app.
  final double widthScale;

  /// Left-hand label text.
  final String label;

  /// Right-hand widget — any widget (dropdown, button, chip, icon row...).
  final Widget? trailing;

  /// Hide the trailing slot without removing it from the call site.
  final bool showTrailing;

  /// Unscaled font size; multiplied by [widthScale].
  final double fontSize;

  /// Defaults to [AppColors.textPrimary].
  final Color? color;

  final FontWeight fontWeight;

  /// Text `height` (design line-height ÷ font size).
  final double lineHeight;

  final double letterSpacing;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow overflow;

  /// Full style override. When provided, the individual text properties above
  /// are ignored except where the style leaves them unset.
  final TextStyle? textStyle;

  /// When true the label takes the remaining width so long text ellipsizes
  /// instead of overflowing. Set false to let it keep its intrinsic width.
  final bool expandLabel;

  /// Unscaled gap between the label and [trailing].
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