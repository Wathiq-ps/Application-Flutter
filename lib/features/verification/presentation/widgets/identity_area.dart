import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/dashed_border.dart';

/// Dashed "tap to upload" area. Shows a preview once [image] is set.
class IdentityUploadArea extends StatelessWidget {
  const IdentityUploadArea({
    super.key,
    required this.image,
    required this.onTap,
    this.icon = AppIcons.camera,
  });

  final XFile? image;
  final VoidCallback? onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;
    final radius = 12 * widthScale;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.white.withValues(alpha: 0.5),
          strokeWidth: 2,
          radius: radius,
        ),
        child: Container(
          width: double.infinity,
          height: 192 * widthScale,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: image == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64 * widthScale,
                height: 64 * widthScale,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  icon,
                  width: 26.67 * widthScale,
                  height: 24 * widthScale,
                  excludeFromSemantics: true,
                ),
              ),
              SizedBox(height: 12 * widthScale),
              Text(
                AppStrings.tapToUpload,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.white,
                  fontSize: 14 * widthScale,
                  height: 20 / 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.14,
                ),
              ),
            ],
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: kIsWeb
                ? Image.network(
              image!.path,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
                : Image.file(
              File(image!.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}