import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';

/// White bottom card: round icon, title, message and one CTA
/// (Figma "Frame 6"). Used by the pending sheet and the pending screen.
class VerificationStatusCard extends StatelessWidget {
  const VerificationStatusCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    this.isLoading = false,
  });

  /// Content of the 96px circle (lottie, spinner, icon...).
  final Widget icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;
    final heightScale = context.heightScale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        25 * widthScale,
        64 * heightScale,
        25 * widthScale,
        24 * heightScale,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35 * widthScale),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96 * widthScale,
              height: 96 * widthScale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    offset: Offset(0, 10 * widthScale),
                    blurRadius: 15 * widthScale,
                    spreadRadius: -3 * widthScale,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: icon,
            ),
            SizedBox(height: 20 * heightScale),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  color: AppColors.primary,
                  fontSize: 35 * widthScale,
                  height: 38 / 35,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.75,
                ),
              ),
            ),
            SizedBox(height: 10 * heightScale),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.primary.withValues(alpha: 0.9),
                fontSize: 16 * widthScale,
                height: 20 / 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 35 * heightScale),
            AppElevatedButton(
              text: buttonText,
              onPressed: onButtonPressed,
              isLoading: isLoading,
              backgroundColor: AppColors.primary,
              borderRadius: 9999,
              elevation: 4,
              textStyle: textTheme.labelMedium?.copyWith(
                color: AppColors.white,
                fontSize: 14 * widthScale,
                height: 24 / 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}