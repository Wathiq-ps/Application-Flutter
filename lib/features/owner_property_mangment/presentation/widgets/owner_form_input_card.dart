import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_icon_label_trigger.dart';

class OwnerFormInputCard extends StatelessWidget {
  const OwnerFormInputCard({
    super.key,
    required this.label,
    required this.value,
    required this.widthScale,
    this.actionIcon,
    this.actionLabel,
    this.switchIconText = true,
    this.onEdit,
    this.valueMaxLines = 1,
    this.suffixText,
    this.suffixIcon,
    this.suffixWidget,
    this.suffixIconWidth = 12,
    this.suffixIconHeight = 12,
    this.actionIconWidth = 12,
    this.actionIconHeight = 12,
  });

  final String label;
  final String value;
  final double widthScale;

  // Top Action Parameters
  final String? actionIcon;
  final String? actionLabel;
  final bool switchIconText;
  final VoidCallback? onEdit;
  final double actionIconWidth;
  final double actionIconHeight;

  // Second Row Parameters
  final int valueMaxLines;
  final String? suffixText;
  final String? suffixIcon;
  final Widget? suffixWidget;
  final double suffixIconWidth;
  final double suffixIconHeight;

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
          // Header Row: Label & AppLabelIconTrigger
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
              if (onEdit != null && actionIcon != null)
                AppLabelIconTrigger(
                  widthScale: widthScale,
                  label: actionLabel ?? AppStrings.editAction,
                  icon: actionIcon!,
                  onTap: onEdit,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                  iconColor: AppColors.primary,
                  iconWidth: actionIconWidth,
                  iconHeight: actionIconHeight,
                  switchIconText: switchIconText,
                ),
            ],
          ),

          SizedBox(height: 10 * widthScale),

          // Value Row: Text & Optional Suffix
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
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
              ),
              if (suffixWidget != null) ...[
                SizedBox(width: 8 * widthScale),
                suffixWidget!,
              ] else if (suffixIcon != null) ...[
                SizedBox(width: 8 * widthScale),
                SvgPicture.asset(
                  suffixIcon!,
                  width: suffixIconWidth * widthScale,
                  height: suffixIconHeight * widthScale,
                ),
              ] else if (suffixText != null) ...[
                SizedBox(width: 8 * widthScale),
                Text(
                  suffixText!,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14 * widthScale,
                    fontWeight: FontWeight.w700,
                    height: 20 / 14,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}