import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';

import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../widgets/auth_action_row.dart';
import '../widgets/phone_number_field.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneNumberController =
  TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

// Figma design dimensions.
    const figmaWidth = 393.0;
    const figmaHeight = 852.0;

// Current screen dimensions.
    final currentScreenWidth = context.screenWidth;
    final currentScreenHeight = context.screenHeight;

// Responsive scale factors.
    final widthScale = currentScreenWidth / figmaWidth;
    final heightScale = currentScreenHeight / figmaHeight;

// Responsive horizontal padding.
    final horizontalPadding = widthScale * 27;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: SvgPicture.asset(
            AppIcons.back,
            width: widthScale * 24,
            height: widthScale * 24,
            excludeFromSemantics: true,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: heightScale * 48,
              ),

// Welcome title.
              Text(
                AppStrings.welcomeBack,
                style: textTheme.headlineLarge?.copyWith(
                  color: AppColors.primary,
                  fontSize: heightScale * 36,
                  height: 45 / 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                ),
              ),

              SizedBox(
                height: heightScale * 16,
              ),

// Description.
              Text(
                AppStrings.enterPhoneNumberToSignIn,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: heightScale * 18,
                  height: 28 / 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(
                height: heightScale * 24,
              ),

// Phone number label.
              Text(
                AppStrings.enterPhoneNumber,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: widthScale * 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(
                height: heightScale * 12,
              ),

// Phone number input.
              PhoneNumberField(
                controller: _phoneNumberController,
              ),

              SizedBox(
                height: heightScale * 24,
              ),

// Send code button.
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton(
                  text: AppStrings.sendCode,
                  onPressed: null,
                  enabled: false,
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.disabled,
                  disabledTextColor: AppColors.textSecondary,
                  height: heightScale * 56,
                  borderRadius: 9999,
                  postIcon: Icon(
                    Icons.arrow_forward,
                    size: widthScale * 16,
                  ),
                  textStyle: textTheme.bodyMedium?.copyWith(
                    fontSize: widthScale * 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const Spacer(),

// Register section.
              AuthActionRow(
                message: AppStrings.dontHaveAccount,
                actionText: AppStrings.signUp,
                messageColor: AppColors.textSecondary,
                actionColor: AppColors.primary,
                onActionPressed: () {
                  context.go(
                    RouteNames.onboardingScreen,
                  );
                },
                textFontSize: widthScale * 14,
                gap: widthScale * 4,
              ),

              SizedBox(
                height: heightScale * 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
