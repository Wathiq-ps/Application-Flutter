import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_circular_icon_button.dart';
import '../../../../core/widget/property_image.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.rooms,
    this.rating,
    this.onTap,
    this.onViewDetails,
    this.isFavorite = false,
    this.onFavoritePressed,
  });
  /// Backend URL, asset path, or null/empty (falls back to the default villa).
  final String? imagePath;
  final String title;
  final String location;
  final String price;
  final String rooms;
  final VoidCallback? onViewDetails;
  final double? rating;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    final double widthScale = context.screenWidth / figmaWidth;
    final double shownRating = rating ?? 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12 * widthScale),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: 118 * widthScale,
          padding: EdgeInsets.all(10 * widthScale),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16 * widthScale),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ───────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(12 * widthScale),
                child: SizedBox(
                  width: 96 * widthScale,
                  height: 96 * widthScale,
                  child: PropertyImage(
                    path: imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 12 * widthScale),

              // ── Details ─────────────────────────────
              Expanded(
                child: SizedBox(
                  height: 96 * widthScale,
                  child: Stack(
                    children: [
                      // Title + location
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 40 * widthScale,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF0A1F44),
                                fontSize: 14 * widthScale,
                                fontWeight: FontWeight.w600,
                                height: 19 / 14,
                              ),
                            ),
                            SizedBox(height: 2 * widthScale),
                            Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF44464E),
                                fontSize: 12 * widthScale,
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Rating (always visible, 0.0 when not rated yet)
                      Positioned(
                        top: 44 * widthScale,
                        right: 0,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.rateStar,
                              width: 18 * widthScale,
                              height: 16 * widthScale,
                              excludeFromSemantics: true,
                            ),
                            SizedBox(width: 4 * widthScale),
                            Text(
                              shownRating.toStringAsFixed(1),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12 * widthScale,
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Favorite button
                      Positioned(
                        top: 0,
                        right: 0,
                        child: AppCircularIconButton(
                          isSelected: true,
                          borderRadius: 99,
                          shadowBlurRadius: 0,
                          blur: isFavorite ? 0 : 6,
                          selectedBackgroundOpacity: isFavorite ? 0 : 0.5,
                          shadowColor:
                          isFavorite ? Colors.transparent : AppColors.black,
                          shadowOpacity: isFavorite ? 0 : 0.05,
                          selectedBackgroundColor: isFavorite
                              ? Colors.white
                              : const Color(0xFFB5C4FF),
                          icon: AppIcons.favouriteSelected,
                          onPressed: onFavoritePressed ?? () {},
                          size: (isFavorite ? 20 : 36) * widthScale,
                          iconWidth: 18 * widthScale,
                          iconHeight: 16 * widthScale,
                        ),
                      ),

                      // Price + View Details button
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                price,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF0A1F44),
                                  fontSize: 14 * widthScale,
                                  fontWeight: FontWeight.w700,
                                  height: 24 / 14,
                                ),
                              ),
                            ),
                            SizedBox(width: 8 * widthScale),
                            GestureDetector(
                              onTap: onViewDetails ?? onTap,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 28 * widthScale,
                                padding: EdgeInsets.symmetric(horizontal: 14 * widthScale),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A1F44),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  AppStrings.viewDetails,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 12 * widthScale,
                                    fontWeight: FontWeight.w500,
                                    height: 16 / 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}