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

  @override
  Widget build(BuildContext context) {
    final bool hasLeft = left != null;
    final bool hasCenter = showCenter && center != null;
    final bool hasRight = showRight && right != null;

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (hasLeft) left!,
          if (hasCenter) ...[
            if (hasLeft && leftGap > 0) SizedBox(width: leftGap * widthScale),
            if (expandCenter) Expanded(child: center!) else Flexible(child: center!),
            if (hasRight && rightGap > 0) SizedBox(width: rightGap * widthScale),
          ],
          if (hasRight) right!,
        ],
      ),
    );
  }
}