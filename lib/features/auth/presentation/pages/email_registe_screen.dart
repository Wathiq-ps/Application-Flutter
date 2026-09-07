import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/features/auth/presentation/state_mangement/cubit/auth_state.dart';
import 'package:mobile/features/auth/presentation/widgets/auth_action_row.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/input_field.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../state_mangement/cubit/auth_cubit.dart';
import '../widgets/otp_bottom_sheet.dart';

class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({super.key});

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _showOverlay = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRegisterSuccess(BuildContext context) async {
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
        return BlocProvider.value(value: authCubit, child: const OtpBottomSheet());
      },
    );

    if (!mounted) return;
    setState(() => _showOverlay = false);

    if (authCubit.state.status == AuthStatus.otpVerified && context.mounted) {
      context.go(RouteNames.addPropertyScreenOne);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Figma reference dimensions.
    final _figmaWidth = 393;
    final _figmaHeight = 852;
    final _currentScreenWidth = context.screenWidth;
    final _currentScreenHeight = context.screenHeight;
    final _widthScale = (_currentScreenWidth / _figmaWidth);
    final _heightScale = (_currentScreenHeight / _figmaHeight);
    final _horizantalPadding = _widthScale * 32;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
        leading: IconButton(
          padding: EdgeInsets.only(left: 5 * _widthScale),
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            AppIcons.back,
            width: _widthScale * 20,
            height: _widthScale * 20,
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
                  stops: const [0.0, 0.40, 1.0],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _horizantalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                Text(
                  AppStrings.getStarted,
                  style: textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: _widthScale * 32,
                    height: (40 / 32),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: _heightScale * 16),

                Text(
                  AppStrings.enterYourEmailAdd,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: _widthScale * 16,
                    height: (24 / 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: _heightScale * 24),

                Text(
                  AppStrings.enterEmail,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.white,
                    fontSize: _widthScale * 14,
                    height: (20 / 14),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: _heightScale * 12),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (BuildContext context, AuthState state) {
                    return InputFieldWidget(
                      hint: AppStrings.emailHintText,
                      controller: _emailController,
                      errorText: state.errorMessage,
                      onChanged: (value) {
                        context.read<AuthCubit>().emailChange(value);
                      },
                    );
                  },
                ),

                SizedBox(height: _heightScale * 24),

                BlocListener<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                  previous.status != current.status && current.status == AuthStatus.otpRequested,
                  listener: (context, state) => _handleRegisterSuccess(context),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AppElevatedButton(
                          text: AppStrings.sendCode,
                          onPressed: () => context.read<AuthCubit>().emailValidate(),

                      );
                    },
                  ),
                ),

                const Spacer(),

                AuthActionRow(
                  message: AppStrings.alreadyHaveAccount,
                  actionText: AppStrings.signIn,
                  onActionPressed: () {
                    context.go(RouteNames.onboardingLoginScreen);
                  },
                  textFontSize: 14 * _widthScale,
                ),

                SizedBox(height: _heightScale * 32),
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

          // Fullscreen celebratory Lottie, shown only during the
          // OTP-verified success state.
          Positioned.fill(
            child: IgnorePointer(
              child: BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) =>
                previous.status != current.status,
                builder: (context, state) {
                  final showConfetti =
                      state.status == AuthStatus.otpVerified;
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