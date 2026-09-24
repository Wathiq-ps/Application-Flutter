import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PropertyCardAction extends StatelessWidget {
  const PropertyCardAction({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.color,
    required this.widthScale,
    this.onTap,
  });

  final String iconAsset;
  final String label;
  final Color color;
  final double widthScale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 12 * widthScale,
            height: 12 * widthScale,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4 * widthScale),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12 * widthScale,
              fontWeight: FontWeight.w600,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}