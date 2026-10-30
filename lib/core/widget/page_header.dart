import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.widthScale,
    this.left,
    this.center,
    this.right,
    this.showCenter = true,
    this.showRight = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.expandCenter = true,
    this.leftGap = 0,
    this.rightGap = 0,
    this.padding = EdgeInsets.zero,
    this.centered = true,
    this.height = 44,
    this.topSpacing = 16,
  });

  final double widthScale;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final bool showCenter;
  final bool showRight;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool expandCenter;
  final double leftGap;
  final double rightGap;
  final EdgeInsetsGeometry padding;
  final bool centered;
  final double height;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    final bool hasLeft = left != null;
    final bool hasCenter = showCenter && center != null;
    final bool hasRight = showRight && right != null;
    final EdgeInsets p = padding.resolve(Directionality.of(context));

    final Widget content = centered
        ? NavigationToolbar(
      leading: hasLeft ? left : null,
      middle: hasCenter ? center : null,
      trailing: hasRight ? right : null,
      centerMiddle: true,
      middleSpacing: 8 * widthScale,
    )
        : Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (hasLeft) left!,
        if (hasCenter) ...[
          if (hasLeft && leftGap > 0) SizedBox(width: leftGap * widthScale),
          if (expandCenter)
            Expanded(child: center!)
          else
            Flexible(child: center!),
          if (hasRight && rightGap > 0)
            SizedBox(width: rightGap * widthScale),
        ],
        if (hasRight) right!,
      ],
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(p.left, topSpacing * widthScale, p.right, 0),
      child: SizedBox(height: height * widthScale, child: content),
    );
  }
}