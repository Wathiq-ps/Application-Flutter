import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'app_circular_icon_button.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.widthScale,
    this.onPressed,
    this.size = 36,
  });

  final bool isFavorite;
  final double widthScale;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AppCircularIconButton(
      icon: isFavorite ? AppIcons.favouriteSelected : AppIcons.favouriteSelected,
      isSelected: isFavorite,
      selectedBackgroundColor: AppColors.secondary,
      onPressed: onPressed,
      size: size * widthScale,
      iconWidth: 18 * widthScale,
      iconHeight: 16 * widthScale,
    );
  }
}


