import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class OwnerPropertyPhotoCard extends StatelessWidget {
  const OwnerPropertyPhotoCard({
    super.key,
    required this.widthScale,
    this.imageUrl,
    this.width = 220,
    this.height = 120,
    this.borderRadius = 8,
    this.showEditBadge = true,
    this.onEdit,
    this.editIcon = Icons.edit_outlined,
  });

  final double widthScale;

  /// Remote image. When null a neutral placeholder box is shown.
  final String? imageUrl;

  /// Unscaled design dimensions.
  final double width;
  final double height;
  final double borderRadius;

  final bool showEditBadge;
  final VoidCallback? onEdit;
  final IconData editIcon;

  bool get _hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = width * widthScale;
    final double cardHeight = height * widthScale;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          Container(
            width: cardWidth,
            height: cardHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.iconBg,
              borderRadius: BorderRadius.circular(borderRadius * widthScale),
            ),
            child: _hasImage
                ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            )
                : null,
          ),
          if (showEditBadge)
            Positioned(
              right: 10 * widthScale,
              top: 8 * widthScale,
              child: GestureDetector(
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(4 * widthScale),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    editIcon,
                    size: 13 * widthScale,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}