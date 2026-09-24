import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../../../core/constant/strings.dart';
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

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.allProperties,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontSize: 18 * ws, fontWeight: FontWeight.w700),
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6 * ws, horizontal: 4 * ws),
                child: Text(
                  AppStrings.viewAll,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 14 * ws,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12 * ws),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          child: properties.isEmpty
              ? Padding(
            key: const ValueKey('empty'),
            padding: EdgeInsets.symmetric(vertical: 48 * ws),
            child: Center(
              child: Text(
                AppStrings.noPropertiesFound,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          )
              : Column(
            key: ValueKey(properties.map((p) => p.id).join()),
            children: [
              for (final property in properties)
                Padding(
                  padding: EdgeInsets.only(bottom: 16 * ws),
                  child: PropertyCard(
                    property: property,
                    widthScale: ws,
                    onTap: onPropertyTap == null ? null : () => onPropertyTap!(property),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}