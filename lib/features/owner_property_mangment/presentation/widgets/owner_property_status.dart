import 'package:flutter/material.dart';

import '../../domain/entities/property_status.dart';

class OwnerPropertyStatusBadge extends StatelessWidget {
  const OwnerPropertyStatusBadge({
    super.key,
    required this.status,
    required this.widthScale,
  });

  final PropertyStatus status;
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * widthScale,
        vertical: 4 * widthScale,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8 * widthScale,
            height: 8 * widthScale,
            decoration: BoxDecoration(
              color: status.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6 * widthScale),
          Text(
            status.label,
            style: TextStyle(
              color: status.textColor,
              fontSize: 12 * widthScale,
              fontWeight: FontWeight.w500,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}