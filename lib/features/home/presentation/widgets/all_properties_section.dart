import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import 'property_card.dart';

class AllPropertiesSection extends StatelessWidget {
  const AllPropertiesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale =
      context.screenWidth / figmaWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.allProperties,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18 * widthScale,
                fontWeight: FontWeight.w600,
                height: 24 / 18,
              ),
            ),

            GestureDetector(
              onTap: () {
                // TODO: Navigate to all properties.
              },
              child: Text(
                AppStrings.viewAll,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11 * widthScale,
                  fontWeight: FontWeight.w400,
                  height: 14 / 11,
                  letterSpacing: 0.44,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: 12 * widthScale,
        ),

         PropertyCard(
          imagePath: ImagePath.villa,
          title: 'Al-Masyoun, \nRamallah',
          location: 'Ramallah',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),

         PropertyCard(
            imagePath: ImagePath.villa,
          title: 'Apartment — 3 rooms',
          location: 'Al-Masyoun, \nRamallah',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),

         PropertyCard(
          imagePath:ImagePath.villa,
          title: 'Apartment — 3 rooms',
          location: 'Al-Masyoun, \nRamallah',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),

        PropertyCard(
          imagePath:ImagePath.villa,
          title: 'Apartment — 3 rooms',
          location: 'Al-Masyoun, \nRamallah',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),
      ],
    );
  }
}