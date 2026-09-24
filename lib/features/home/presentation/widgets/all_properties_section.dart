import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/utils/price_formatter.dart';
import 'property_card.dart';

class AllPropertiesSection extends StatelessWidget {
  const AllPropertiesSection({
    super.key,
    required this.properties,
    required this.widthScale,
    required this.onViewAll,
    this.onPropertyTap,
  });

  final List<PropertyEntity> properties;
  final double widthScale;
  final VoidCallback onViewAll;
  final ValueChanged<PropertyEntity>? onPropertyTap;

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  static String _roomsLabel(int rooms) => rooms == 1 ? '1 room' : '$rooms rooms';

  @override
  Widget build(BuildContext context) {
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
              onTap: onViewAll,
              behavior: HitTestBehavior.opaque,
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

        SizedBox(height: 12 * widthScale),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          child: properties.isEmpty
              ? Padding(
            key: const ValueKey('empty'),
            padding: EdgeInsets.symmetric(vertical: 48 * widthScale),
            child: Center(
              child: Text(
                AppStrings.noPropertiesFound,
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  fontSize: 14 * widthScale,
                ),
              ),
            ),
          )
              : Column(
            key: ValueKey(properties.map((p) => p.id).join()),
            children: [
              for (final property in properties)
                PropertyCard(
                  // null / empty -> default villa (handled by PropertyImage)
                  imagePath: property.coverPhoto,
                  title:
                  '${_capitalize(property.type)} — ${_roomsLabel(property.rooms)}',
                  location: property.locationLabel,
                  price: PriceFormatter.displayWithCode(
                    price: property.price,
                    currency: property.priceCurrency,
                    unit: property.priceUnit,
                  ),
                  rooms: _roomsLabel(property.rooms),
                  // no For Sale / For Rent badge here
                  rating: property.averageRating, // null -> 0.0
                  onTap: onPropertyTap == null
                      ? null
                      : () => onPropertyTap!(property),
                ),
            ],
          ),
        ),
      ],
    );
  }
}