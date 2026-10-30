import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import 'verification_status_card.dart';

class VerificationPendingSheet extends StatelessWidget {
  const VerificationPendingSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.transparent,
      barrierColor: AppColors.primaryDark.withValues(alpha: 0.63),
      builder: (_) => const VerificationPendingSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widthScale = context.widthScale;

    return PopScope(
      canPop: false,
      child: VerificationStatusCard(
        icon: SizedBox(
          width: 80 * widthScale,
          height: 80 * widthScale,
          child: Lottie.asset(ImagePath.minimalClock, fit: BoxFit.contain),
        ),
        title: AppStrings.verificationPending,
        message: AppStrings.verificationPendingDescription,
        buttonText: AppStrings.backToHome,
        onButtonPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}