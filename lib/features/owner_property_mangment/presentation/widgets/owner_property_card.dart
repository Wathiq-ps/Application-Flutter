import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../../domain/entities/property_status.dart';
import '../state_management/owner_property_state.dart';
import 'owner_property_status.dart';

class OwnerPropertyCard extends StatelessWidget {
  const OwnerPropertyCard({
    super.key,
    required this.property,
    required this.widthScale,
    required this.showStatus,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
  });

  final OwnerPropertyListItem property;
  final double widthScale;
  final bool showStatus;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            spreadRadius: 3,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─────────────────────────────────────
          // Thumbnail + status badge
          // ─────────────────────────────────────
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 176 * widthScale,
                color: AppColors.iconBg,
                child: property.imageUrl.isEmpty
                    ? null
                    : Image.network(
                  property.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              if (showStatus)
                Positioned(
                  left: 17 * widthScale,
                  top: 14 * widthScale,
                  child: OwnerPropertyStatusBadge(
                    status: property.status,
                    widthScale: widthScale,
                  ),
                ),
            ],
          ),

          // ─────────────────────────────────────
          // Details
          // ─────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16 * widthScale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w600,
                    height: 24 / 18,
                    letterSpacing: -0.45,
                  ),
                ),

                SizedBox(height: 10 * widthScale),

                Text(
                  property.location,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12 * widthScale,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),

                SizedBox(height: 10 * widthScale),

                // Specs chips
                Row(
                  children: [
                    _SpecChip(
                      icon: Icons.bed_outlined,
                      label: '${property.rooms} rooms',
                      widthScale: widthScale,
                    ),
                    SizedBox(width: 8 * widthScale),
                    _SpecChip(
                      icon: Icons.bathtub_outlined,
                      label: '${property.bathrooms} baths',
                      widthScale: widthScale,
                    ),
                    SizedBox(width: 8 * widthScale),
                    _SpecChip(
                      icon: Icons.square_foot_outlined,
                      label: '${property.areaSqm} m²',
                      widthScale: widthScale,
                    ),
                  ],
                ),

                SizedBox(height: 12 * widthScale),

                Container(
                  padding: EdgeInsets.only(top: 8 * widthScale),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.filterChipUnselectedBorderColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.price,
                            style: TextStyle(
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.3,
                              ),
                              fontSize: 11 * widthScale,
                              fontWeight: FontWeight.w600,
                              height: 14 / 11,
                              letterSpacing: 0.44,
                            ),
                          ),
                          Text(
                            '${property.price} ${property.priceUnit}',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18 * widthScale,
                              fontWeight: FontWeight.w700,
                              height: 28 / 18,
                              letterSpacing: -0.22,
                            ),
                          ),
                        ],
                      ),

                      AppElevatedButton(
                        text: AppStrings.viewDetails,
                        onPressed: onViewDetails ?? () {},
                        width: 104 * widthScale,
                        height: 32 * widthScale,
                        backgroundColor: AppColors.primary,
                        borderRadius: 9999,
                        elevation: 0,
                        textStyle: TextStyle(
                          color: AppColors.white,
                          fontSize: 12 * widthScale,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.24,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12 * widthScale),

                Row(
                  children: [
                    _CardTextAction(
                      icon: Icons.edit_outlined,
                      label: AppStrings.editAction,
                      color: AppColors.primary,
                      widthScale: widthScale,
                      onTap: onEdit,
                    ),
                    SizedBox(width: 16 * widthScale),
                    _CardTextAction(
                      icon: Icons.delete_outline,
                      label: AppStrings.deleteAction,
                      color: AppColors.error,
                      widthScale: widthScale,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({
    required this.icon,
    required this.label,
    required this.widthScale,
  });

  final IconData icon;
  final String label;
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * widthScale,
        vertical: 4 * widthScale,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8 * widthScale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14 * widthScale,
            color: AppColors.primary,
          ),
          SizedBox(width: 4 * widthScale),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11 * widthScale,
              fontWeight: FontWeight.w600,
              height: 14 / 11,
              letterSpacing: 0.44,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTextAction extends StatelessWidget {
  const _CardTextAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.widthScale,
    this.onTap,
  });

  final IconData icon;
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
          Icon(icon, size: 12 * widthScale, color: color),
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