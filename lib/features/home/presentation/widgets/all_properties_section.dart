import 'package:flutter/material.dart';

import '../../../../core/constant/strings.dart';
import 'property_card.dart';

class AllPropertiesSection extends StatelessWidget {
  const AllPropertiesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale =
        MediaQuery.sizeOf(context).width / figmaWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─────────────────────────────────────
        // Section Header
        // ─────────────────────────────────────

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppStrings.allProperties,
              style: TextStyle(
                color: const Color(0xFF00113A),
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
                  color: const Color(0xFF00113A),
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

        // ─────────────────────────────────────
        // Property List
        // ─────────────────────────────────────

        const PropertyCard(
          imagePath: 'assets/images/home/property_1.jpg',
          title: 'Apartment — 3 rooms',
          location: 'Ramallah',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),

        SizedBox(
          height: 12 * widthScale,
        ),

        const PropertyCard(
          imagePath: 'assets/images/home/property_2.jpg',
          title: 'Apartment — 3 rooms',
          location: 'Al-Bireh',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),

        SizedBox(
          height: 12 * widthScale,
        ),

        const PropertyCard(
          imagePath: 'assets/images/home/property_3.jpg',
          title: 'Apartment — 3 rooms',
          location: 'Ramallah',
          price: '85,000 JOD',
          type: 'For Sale',
          rooms: '3 rooms',
        ),
      ],
    );
  }
}