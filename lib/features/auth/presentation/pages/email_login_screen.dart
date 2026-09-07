import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/input_field.dart';
import '../state_mangement/cubit/auth_cubit.dart';
import '../state_mangement/cubit/auth_state.dart';
import '../widgets/auth_action_row.dart';
import '../widgets/otp_bottom_sheet.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _showOverlay = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleOtpRequested(BuildContext context) async {
    final authCubit = context.read<AuthCubit>();

    setState(() => _showOverlay = true);

    AppTopSnackBar.show(
      context,
      title: AppStrings.codeSent,
      message: AppStrings.checkEmailForVerificationCode,
      prefixIcon: AppIcons.success,
      duration: const Duration(milliseconds: 2000),
    );

    await Future.delayed(const Duration(milliseconds: 2000));
    if (!context.mounted) return;
    authCubit.prepareOtpStep();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: authCubit,
          child: const OtpBottomSheet(),
        );
      },
    );

    if (!mounted) return;
    setState(() => _showOverlay = false);

    if (authCubit.state.status == AuthStatus.otpVerified && context.mounted) {
      context.go(RouteNames.reviewListingPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    const figmaWidth = 393.0;
    const figmaHeight = 852.0;

    final currentScreenWidth = context.screenWidth;
    final currentScreenHeight = context.screenHeight;

    final widthScale = currentScreenWidth / figmaWidth;
    final heightScale = currentScreenHeight / figmaHeight;

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
          Positioned.fill(
            child: Image.asset(
              ImagePath.background,
              fit: BoxFit.cover,
            ),
          ),

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

                BlocListener<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                  previous.status != current.status &&
                      current.status == AuthStatus.requestError,
                  listener: (context, state) {
                    AppTopSnackBar.show(
                      context,
                      title: AppStrings.verificationFailed,
                      message: state.errorMessage ?? AppStrings.somethingWentWrong,
                      prefixIcon: AppIcons.error,
                    );
                  },
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (BuildContext context, AuthState state) {
                      return InputFieldWidget(
                        hint: AppStrings.emailHint,
                        controller: _emailController,
                        errorText: state.status == AuthStatus.validationError
                            ? state.errorMessage
                            : null,
                        onChanged: (value) {
                          context.read<AuthCubit>().emailChange(value);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(
                  height: heightScale * 24,
                ),

                BlocListener<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                  previous.status != current.status &&
                      current.status == AuthStatus.otpRequested,
                  listener: (context, state) {
                    _handleOtpRequested(context);
                  },
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (BuildContext context, AuthState state) {
                      return AppElevatedButton(
                        text: AppStrings.sendCode,
                        onPressed: state.isLoading
                            ? null
                            : () {
                          context.read<AuthCubit>().emailValidate();
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
                      );
                    },
                  ),
                ),

                const Spacer(),

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

          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_showOverlay,
              child: AnimatedOpacity(
                opacity: _showOverlay ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  color: AppColors.primaryDark.withValues(alpha: 0.63),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) =>
                previous.status != current.status,
                builder: (context, state) {
                  final showConfetti = state.status == AuthStatus.otpVerified;
                  return AnimatedOpacity(
                    opacity: showConfetti ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: showConfetti
                        ? Lottie.asset(
                      ImagePath.welcomeTopDecorations,
                      fit: BoxFit.cover,
                      repeat: false,
                    )
                        : const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}