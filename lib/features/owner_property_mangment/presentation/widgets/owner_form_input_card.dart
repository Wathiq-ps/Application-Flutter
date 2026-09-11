import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

class OwnerFormInputCard extends StatelessWidget {
  const OwnerFormInputCard({
    super.key,
    required this.label,
    required this.value,
    required this.widthScale,
    this.onEdit,
    this.valueMaxLines = 1,
  });

  final String label;
  final String value;
  final double widthScale;
  final VoidCallback? onEdit;
  final int valueMaxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15 * widthScale),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16 * widthScale),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12 * widthScale,
                  fontWeight: FontWeight.w700,
                  height: 16 / 12,
                  letterSpacing: 0.24,
                ),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 12 * widthScale,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4 * widthScale),
                      Text(
                        AppStrings.editAction,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12 * widthScale,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 10 * widthScale),

          Text(
            value,
            maxLines: valueMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16 * widthScale,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
            ),
          ),
        ],
      ),
    );
  }
}