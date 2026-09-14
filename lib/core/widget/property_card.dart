import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/property_card_action.dart';
import '../../../../core/widget/property_spec_chip.dart';
import '../../features/owner_property_mangment/domain/entities/owner_property_list_item.dart';
import '../../features/owner_property_mangment/presentation/widgets/owner_property_status.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    required this.widthScale,
    required this.showStatus,
    this.propMang = false,
    this.localImagePath,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
  });

  final OwnerPropertyListItem property;
  final double widthScale;
  final bool showStatus;
  final bool propMang;
  final String? localImagePath;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;


  String get _resolvedImagePath {
    if (localImagePath != null && localImagePath!.trim().isNotEmpty) {
      return localImagePath!;
    }
    if (property.imageUrl != null && property.imageUrl!.trim().isNotEmpty) {
      return property.imageUrl!;
    }
    return ImagePath.villa;
  }

  bool get _isNetworkImage =>
      _resolvedImagePath.startsWith('http://') ||
          _resolvedImagePath.startsWith('https://');

  Widget _buildImage(BuildContext context, ColorScheme colorScheme) {
    final errorFallback = Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: colorScheme.onSurface,
      ),
    );

    if (_isNetworkImage) {
      return Image.network(
        _resolvedImagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => errorFallback,
      );
    }

    return Image.asset(
      _resolvedImagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => errorFallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
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
                child: _buildImage(context, colorScheme),
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
            padding: EdgeInsets.only(top: 16 * widthScale, left: 16 * widthScale,right: 16 * widthScale,bottom: 23 * widthScale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: (textTheme.bodyLarge ?? const TextStyle()).copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w600,
                    height: 24 / 18,
                    letterSpacing: -0.45,
                  ),
                ),

                SizedBox(height: 10 * widthScale),

                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.location,
                      width: 14 * widthScale,
                      height: 14 * widthScale,
                      colorFilter: ColorFilter.mode(
                        colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4 * widthScale),
                    Text(
                      property.location,
                      style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 12 * widthScale,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10 * widthScale),

                // Specs chips
                Row(
                  children: [
                    PropertySpecChip(
                      iconAsset: AppIcons.bed,
                      label: '${property.rooms}${AppStrings.beds}',
                      widthScale: widthScale,
                    ),
                    SizedBox(width: 8 * widthScale),
                    PropertySpecChip(
                      iconAsset: AppIcons.bath,
                      label: '${property.bathrooms}${AppStrings.baths}',
                      widthScale: widthScale,
                    ),
                    SizedBox(width: 8 * widthScale),
                    PropertySpecChip(
                      iconAsset: AppIcons.area,
                      label: '${property.areaSqm}${AppStrings.sqm}',
                      widthScale: widthScale,
                    ),
                  ],
                ),

                SizedBox(height: 12 * widthScale),

                Container(
                  padding: EdgeInsets.only(top: 8 * widthScale),
                  decoration: const BoxDecoration(
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
                            style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.3),
                              fontSize: 11 * widthScale,
                              fontWeight: FontWeight.w600,
                              height: 14 / 11,
                              letterSpacing: 0.44,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${property.price} ',
                                  style: (textTheme.bodyLarge ?? const TextStyle()).copyWith(
                                    color: colorScheme.onSurface,
                                    fontSize: 18 * widthScale,
                                    fontWeight: FontWeight.w700,
                                    height: 28 / 18,
                                    letterSpacing: -0.22,
                                  ),
                                ),
                                TextSpan(
                                  text: property.priceUnit,
                                  style: (textTheme.bodyLarge ?? const TextStyle()).copyWith(
                                    fontSize: 18 * widthScale,
                                    fontWeight: FontWeight.w700,
                                    height: 28 / 18,
                                    letterSpacing: -0.22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      AppElevatedButton(
                        text: AppStrings.viewDetails,
                        onPressed: onViewDetails ?? () {},
                        width: 104 * widthScale,
                        height: 32 * widthScale,
                        backgroundColor: colorScheme.primary,
                        borderRadius: 9999,
                        elevation: 0,
                        textStyle: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                          color: colorScheme.onPrimary,
                          fontSize: 12 * widthScale,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.24,
                        ),
                      ),
                    ],
                  ),
                ),

                if (propMang) ...[
                  SizedBox(height: 32 * widthScale),
                  Row(
                    children: [
                      PropertyCardAction(
                        iconAsset: AppIcons.edit,
                        label: AppStrings.editAction,
                        color: colorScheme.primary,
                        widthScale: widthScale,
                        onTap: onEdit,
                      ),
                      SizedBox(width: 18 * widthScale),
                      PropertyCardAction(
                        iconAsset: AppIcons.delete,
                        label: AppStrings.deleteAction,
                        color: colorScheme.error,
                        widthScale: widthScale,
                        onTap: onDelete,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}