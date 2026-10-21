import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';

/// "Take Photo" + "Gallery" outlined button pair (Figma "Action Pair").
class ImageSourceButtons extends StatelessWidget {
  const ImageSourceButtons({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
    this.enabled = true,
  });

  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;
  final bool enabled;

  Widget _button(
      BuildContext context, {
        required String text,
        required String icon,
        required VoidCallback onPressed,
      }) {
    final widthScale = context.widthScale;

    return AppElevatedButton(
      text: text,
      onPressed: onPressed,
      enabled: enabled,
      backgroundColor: AppColors.transparent,
      disabledBackgroundColor: AppColors.transparent,
      disabledTextColor: AppColors.white60,
      enableBorder: true,
      borderColor: AppColors.white.withValues(alpha: 0.2),
      height: 46 * widthScale,
      borderRadius: 9999,
      iconGap: 8 * widthScale,
      iconSize: 15 * widthScale,
      preIcon: SvgPicture.asset(
        icon,
        excludeFromSemantics: true,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      ),
      textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.white,
        fontSize: 14 * widthScale,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthScale = context.widthScale;

    return Row(
      children: [
        Expanded(
          child: _button(
            context,
            text: AppStrings.takePhoto,
            icon: AppIcons.camera,
            onPressed: onCameraPressed,
          ),
        ),
        SizedBox(width: 16 * widthScale),
        Expanded(
          child: _button(
            context,
            text: AppStrings.gallery,
            icon: AppIcons.gallery,
            onPressed: onGalleryPressed,
          ),
        ),
      ],
    );
  }
}