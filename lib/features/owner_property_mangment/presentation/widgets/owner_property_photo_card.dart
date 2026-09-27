import 'package:flutter/material.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/widget/app_circular_icon_button.dart';
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
    this.icon =  AppIcons.circleCloseBlue,
  });

  final double widthScale;
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  final bool showEditBadge;
  final VoidCallback? onEdit;
  final String icon;

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
              right: 3 * widthScale,
              top: 5 * widthScale,
              child: GestureDetector(
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: AppCircularIconButton(
                  iconWidth:23 * widthScale ,
                    iconHeight: 23 * widthScale,
                    icon:
                   icon, onPressed: (){})
              ),
            ),
        ],
      ),
    );
  }
}