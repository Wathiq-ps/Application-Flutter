import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';

import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/input_field.dart';
import '../widgets/auth_action_row.dart';
import '../widgets/otp_bottom_sheet.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

// Figma reference dimensions.
    const figmaWidth = 393.0;
    const figmaHeight = 852.0;

// Current screen dimensions.
    final currentScreenWidth = context.screenWidth;
    final currentScreenHeight = context.screenHeight;

// Responsive scale factors.
    final widthScale = currentScreenWidth / figmaWidth;
    final heightScale = currentScreenHeight / figmaHeight;

// Responsive horizontal padding.
    final horizontalPadding = widthScale * 32;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          padding: EdgeInsets.only(
            left: 5 * widthScale,
          ),
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            AppIcons.back,
            width: widthScale * 20,
            height: widthScale * 20,
            excludeFromSemantics: true,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
// Background image.
          Positioned.fill(
            child: Image.asset(
              ImagePath.background,
              fit: BoxFit.cover,
            ),
          ),

// Same gradient used by EmailRegisterScreen.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.2),
                    AppColors.black.withValues(alpha: 0.60),
                    AppColors.backgroundGradient.withValues(alpha: 0.95),
                  ],
                  stops: const [
                    0.0,
                    0.40,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

// Welcome title.
                Text(
                  AppStrings.welcomeBack,
                  style: textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: widthScale * 32,
                    height: 40 / 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(
                  height: heightScale * 16,
                ),

// Description.
                Text(
                  AppStrings.enterEmailAddressToSignIn,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: widthScale * 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: heightScale * 24,
                ),

// Email label.
                Text(
                  AppStrings.enterEmail,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: widthScale * 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: heightScale * 12,
                ),

// Email input.
                InputFieldWidget(
                  hint: AppStrings.emailHint,
                  controller: _emailController,
                ),

                SizedBox(
                  height: heightScale * 24,
                ),

// Continue with Email.
                AppElevatedButton(
                  text: AppStrings.sendCode,
                  onPressed: () {
                    showOtpBottomSheet(context);
                  },
                  backgroundColor: AppColors.primary,
                  height: (widthScale * 58).clamp(20, 130),
                  width: double.infinity,
                  borderRadius: 9999,
                  borderWidth: 1,
                  postIcon: SvgPicture.asset(
                    AppIcons.send,
                    width: widthScale * 20,
                    height: widthScale * 20,
                    excludeFromSemantics: true,
                  ),
                  iconSize: 15 * widthScale,
                  iconGap: 8 * widthScale,
                  textStyle: textTheme.bodyMedium?.copyWith(
                    fontSize: widthScale * 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),

                const Spacer(),

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
                  height: heightScale * 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showOtpBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const OtpBottomSheet(),
  );
}
