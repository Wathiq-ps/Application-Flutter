import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/utils/price_formatter.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';

import '../../../../core/constant/strings.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    required this.widthScale,
    this.onTap,
  });

  final PropertyEntity property;
  final double widthScale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final isRent = property.listingType == PropertyListingType.rent;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20 * ws),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 170 * ws,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Cover(url: property.coverPhoto, widthScale: ws),
                  PositionedDirectional(
                    top: 12 * ws,
                    start: 12 * ws,
                    child: _Pill(
                      text: isRent ? AppStrings.forRent : AppStrings.forSale,
                      background: AppColors.primary,
                      foreground: AppColors.white,
                      widthScale: ws,
                    ),
                  ),
                  if (property.averageRating != null)
                    PositionedDirectional(
                      top: 12 * ws,
                      end: 12 * ws,
                      child: _Pill(
                        icon: Icons.star_rounded,
                        text: property.averageRating!.toStringAsFixed(1),
                        background: AppColors.white,
                        foreground: AppColors.black,
                        widthScale: ws,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14 * ws),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16 * ws,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4 * ws),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 15 * ws, color: muted),
                      SizedBox(width: 4 * ws),
                      Expanded(
                        child: Text(
                          property.locationLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontSize: 13 * ws, color: muted),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * ws),
                  Row(
                    children: [
                      _Spec(icon: Icons.bed_outlined, label: '${property.rooms}', ws: ws, color: muted),
                      SizedBox(width: 16 * ws),
                      _Spec(icon: Icons.bathtub_outlined, label: '${property.bathrooms}', ws: ws, color: muted),
                      SizedBox(width: 16 * ws),
                      _Spec(icon: Icons.square_foot_rounded, label: '${property.areaSqm.round()} m²', ws: ws, color: muted),
                    ],
                  ),
                  SizedBox(height: 12 * ws),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          PriceFormatter.display(
                            price: property.price,
                            currency: property.priceCurrency,
                            unit: property.priceUnit,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 16 * ws,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (property.isFurnished)
                        Text(
                          AppStrings.furnished,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontSize: 12 * ws, color: muted),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url, required this.widthScale});
  final String? url;
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(Icons.home_work_outlined,
            size: 48 * widthScale, color: AppColors.primary.withValues(alpha: 0.4)),
      ),
    );
    if (url == null) return placeholder;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null ? child : placeholder,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.background,
    required this.foreground,
    required this.widthScale,
    this.icon,
  });

  final String text;
  final Color background;
  final Color foreground;
  final double widthScale;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * widthScale, vertical: 5 * widthScale),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14 * widthScale, color: const Color(0xFFFFB400)),
            SizedBox(width: 3 * widthScale),
          ],
          Text(text,
              style: TextStyle(
                  color: foreground, fontSize: 12 * widthScale, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.label, required this.ws, required this.color});
  final IconData icon;
  final String label;
  final double ws;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16 * ws, color: color),
        SizedBox(width: 4 * ws),
        Text(label, style: TextStyle(fontSize: 13 * ws, color: color)),
      ],
    );
  }
}