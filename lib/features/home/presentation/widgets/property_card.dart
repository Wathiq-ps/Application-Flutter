import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_circular_icon_button.dart';

class PropertyCard extends StatelessWidget {
   PropertyCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.rooms,
    this.onTap,
    this.isFavorite = false,
    this.onFavoritePressed,
  });

  final String imagePath;
  final String title;
  final String location;
  final String price;
  final String type;
  final String rooms;
  final VoidCallback? onTap;
   bool isFavorite;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale =
        context.screenWidth / figmaWidth;

    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 12 * widthScale),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 118 * widthScale,
          padding: EdgeInsets.all(10 * widthScale),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(
              16 * widthScale,
            ),
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

              ClipRRect(
                borderRadius: BorderRadius.circular(
                  12 * widthScale,
                ),
                child: SizedBox(
                  width: 96 * widthScale,
                  height: 96 * widthScale,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(
                width: 12 * widthScale,
              ),

              Expanded(
                child: SizedBox(
                  height: 96 * widthScale,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // Title
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

                            SizedBox(
                              height: 2 * widthScale,
                            ),

                            // Location / rooms
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    location,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color:
                                      const Color(0xFF44464E),
                                      fontSize: 12 * widthScale,
                                      fontWeight:
                                      FontWeight.w400,
                                      height: 16 / 12,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                          top: 50 * widthScale,
                          right: 0,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: onFavoritePressed,
                                child: SvgPicture.asset(
                                  isFavorite
                                      ? AppIcons.rateStar
                                      : AppIcons.rateStar,
                                  width: 18 * widthScale,
                                  height: 16 * widthScale,
                                ),
                              ),
                              SizedBox(width: 4 * widthScale,),
                              Text(
                                '4.9',
                                overflow:
                                TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:AppColors.primary,
                                  fontSize: 12 * widthScale,
                                  fontWeight:
                                  FontWeight.w400,
                                  height: 16 / 12,
                                ),
                              ),
                            ],
                          )
                      ),

                Positioned(
                top: 0,
                right: 0,
                child: AppCircularIconButton(
                isSelected: true,
                borderRadius: 99,
                shadowBlurRadius: 0,
                blur: isFavorite ? 0: 6,
                selectedBackgroundOpacity: isFavorite ? 0 : 0.5,
                shadowColor:isFavorite ? Colors.transparent : AppColors.black,
                shadowOpacity:isFavorite ? 0: 0.05,
                selectedBackgroundColor: isFavorite ? Colors.white :  Color(0xFFB5C4FF),
                icon: AppIcons.favouriteSelected,
                onPressed: (){
                  isFavorite = true;
                  },
                size: (isFavorite ? 20 : 36) * widthScale,
                iconWidth: 18 * widthScale,
                iconHeight: 16 * widthScale,
                ),
              ),


               Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                color: const Color(0xFF0A1F44),
                                fontSize: 14 * widthScale,
                                fontWeight: FontWeight.w700,
                                height: 24 / 14,
                              ),
                            ),

                            const Spacer(),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8 * widthScale,
                                vertical: 2 * widthScale,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x80DAE2FF),
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11 * widthScale,
                                  fontWeight: FontWeight.w600,
                                  height: 14 / 11,
                                  letterSpacing: 0.44,
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