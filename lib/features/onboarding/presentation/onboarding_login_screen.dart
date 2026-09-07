import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';

import '../../../config/routes/routes_names.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constant/app_icons.dart';
import '../../../core/constant/images_path.dart';
import '../../../core/constant/strings.dart';
import '../../../core/widget/app_button.dart';
import '../../../core/widget/app_top_snackbar.dart';
import '../../auth/presentation/widgets/auth_action_row.dart';

class OnBoardingLoginScreen extends StatelessWidget {
  const OnBoardingLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

// Figma design dimensions.
    const figmaWidth = 393.0;
    const figmaHeight = 852.0;

// Current device dimensions.
    final currentScreenWidth = context.screenWidth;
    final currentScreenHeight = context.screenHeight;

// Responsive scale factors.
    final widthScale = currentScreenWidth / figmaWidth;
    final heightScale = currentScreenHeight / figmaHeight;

// Responsive horizontal padding based on the Figma design.
    final horizontalPadding = widthScale * 32;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
// Background image.
          Positioned.fill(
            child: Image.asset(
              ImagePath.background,
              fit: BoxFit.fill,
            ),
          ),

// Dark gradient overlay for better readability.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.50),
                    AppColors.backgroundGradient.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

// Screen content.
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppStrings.welcomeBack,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: widthScale * 36,
                    height: 45 / 36,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.9,
                  ),
                ),

                SizedBox(
                  height: heightScale * 6,
                ),

                Text(
                  AppStrings.signInToContinueSearch,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondary,
                    fontSize: widthScale * 18,
                    height: 28 / 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: heightScale * 74,
                ),

// Continue with Email.
                AppElevatedButton(
                  text: AppStrings.continueWithEmail,
                  onPressed: () {
                    context.push(
                      RouteNames.emailLoginScreen,
                    );
                  },
                  backgroundColor: AppColors.white,
                  height:(widthScale * 56).clamp(20, 100),
                  width: double.infinity,
                  borderRadius: 50,
                  enableBorder: true,
                  borderColor: AppColors.border,
                  borderWidth: 1,
                  preIcon: SvgPicture.asset(
                    AppIcons.gmail,
                    width: widthScale * 20,
                    height: widthScale * 20,
                    excludeFromSemantics: true,
                  ),
                  textStyle: textTheme.bodyMedium?.copyWith(
                    fontSize: widthScale * 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  iconGap: 13 * widthScale,
                ),

                SizedBox(
                  height: heightScale * 16,
                ),

// Continue with Phone.
                AppElevatedButton(
                  text: AppStrings.continueWithPhone,
                  onPressed: () {
                    AppTopSnackBar.show(
                      context,
                      title:AppStrings.featureNotAvailable ,
                      message: AppStrings.featureWillBeAvailbleLater,
                      prefixIcon: AppIcons.error,
                    );
                  },
                  backgroundColor: AppColors.transparent,
                  enableBorder: true,
                  borderColor: AppColors.border.withValues(
                    alpha: 0.5,
                  ),
                  height: (widthScale * 56).clamp(20, 100),
                  width: double.infinity,
                  borderRadius: 9999,
                  preIcon: SvgPicture.asset(
                    AppIcons.phone,
                    width: widthScale * 20,
                    height: widthScale * 20,
                    excludeFromSemantics: true,
                  ),
                  textStyle: textTheme.bodyMedium?.copyWith(
                    fontSize: widthScale * 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                  iconGap: 13 * widthScale,
                ),

                SizedBox(
                  height: heightScale * 61,
                ),

// Register section.
                AuthActionRow(
                  message: AppStrings.dontHaveAccount,
                  actionText: AppStrings.signUp,
                  messageColor: AppColors.white.withValues(
                    alpha: 0.47,
                  ),
                  actionColor: AppColors.white,
                  onActionPressed: () {
                    context.go(
                      RouteNames.onboardingScreen,
                    );
                  },
                  textFontSize: 14 * widthScale,
                  gap: 4 * widthScale,
                ),

                SizedBox(
                  height: heightScale * 39,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
