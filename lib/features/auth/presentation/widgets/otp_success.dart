import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/constant/strings.dart';

import '../../../../core/extensions/media_query_extensions.dart';

class OtpSuccessView extends StatelessWidget {
  const OtpSuccessView({super.key});

  static const double _figmaWidth = 393;
  static const double _figmaHeight = 852;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final widthScale = context.screenWidth / _figmaWidth;
    final heightScale = context.screenHeight / _figmaHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 80 * heightScale),
        SizedBox(
          width: 96 * widthScale,
          height: 96 * widthScale,
          child: Lottie.asset(
            ImagePath.circularProgressCheck,
            fit: BoxFit.contain,
            repeat: false,
          ),
        ),
        SizedBox(height: 24 * heightScale),
        Text(
          AppStrings.welcomeToWathiq,
          textAlign: TextAlign.center,
          style: textTheme.headlineLarge?.copyWith(
            fontSize: 35 * widthScale,
            fontWeight: FontWeight.w500,
            height: 40 / 35,
            letterSpacing: -0.8,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8 * heightScale),
        Text(
          AppStrings.letGetStarted,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 18 * widthScale,
            height: 26 / 18,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 40 * heightScale),
        SizedBox(
          width: 310 * widthScale,
          height: 8 * heightScale,
          child: Lottie.asset(
            ImagePath.progressBar,
            fit: BoxFit.fill,
            repeat: false,
          ),
        ),
        SizedBox(height: 50*heightScale,)
      ],
    );
  }
}