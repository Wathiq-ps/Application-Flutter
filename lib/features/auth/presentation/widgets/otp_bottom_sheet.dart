import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/widget/app_button.dart';
import 'package:mobile/core/widget/app_top_snackbar.dart';
import 'package:mobile/features/auth/presentation/state_mangement/cubit/register/register_cubit.dart';
import 'package:mobile/features/auth/presentation/state_mangement/cubit/register/register_state.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/extensions/media_query_extensions.dart';
import 'auth_action_row.dart';
import 'otp_success.dart';

class OtpBottomSheet extends StatefulWidget {
  const OtpBottomSheet({super.key});

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();

  static const double _figmaWidth = 393;
  static const double _figmaHeight = 852;

  Timer? _autoCloseTimer;

  @override
  void dispose() {
    _otpController.dispose();
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _scheduleAutoClose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final widthScale = context.screenWidth / _figmaWidth;

    return Padding(
      padding: EdgeInsets.only(bottom: context.keyboardBottomInset),
      child: Container(
        padding: EdgeInsets.all(24 * widthScale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35 * widthScale),
          ),
        ),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == RegisterStatus.error &&
                state.errorMessage != null) {
              AppTopSnackBar.show(
                context,
                title: 'Verification failed',
                message: state.errorMessage!,
                prefixIcon: AppIcons.error,
              );
            } else if (state.status == RegisterStatus.otpVerified) {
              _scheduleAutoClose();
            }
          },
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            if (state.status == RegisterStatus.otpVerified) {
              return const OtpSuccessView();
            }
            return _OtpForm(controller: _otpController);
          },
        ),
      ),
    );
  }
}

class _OtpForm extends StatelessWidget {
  final TextEditingController controller;

  const _OtpForm({required this.controller});

  static const double _figmaWidth = 393;
  static const double _figmaHeight = 852;

  int _fontSize(BuildContext context) {
    if (context.screenHeight > 1020) {
      return 10;
    } else {
      return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<RegisterCubit>();

    final widthScale = context.screenWidth / _figmaWidth;
    final heightScale = context.screenHeight / _figmaHeight;

    final defaultPinTheme = PinTheme(
      width: 64 * widthScale,
      height: 80 * heightScale,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12 * widthScale),
      ),
    );

    final activePinTheme = PinTheme(
      textStyle: textTheme.headlineLarge?.copyWith(
        fontSize: 30 * widthScale,
        color: AppColors.primary,
      ),
      width: 64 * widthScale,
      height: 80 * heightScale,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12 * widthScale),
      ),
    );

    final errorPinTheme = PinTheme(
      textStyle: textTheme.headlineLarge?.copyWith(
        fontSize: 30 * widthScale,
        color: AppColors.primary,
      ),
      width: 64 * widthScale,
      height: 80 * heightScale,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.error),
        borderRadius: BorderRadius.circular(12 * widthScale),
      ),
    );

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final hasError = state.status == RegisterStatus.error;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Code',
              style: textTheme.headlineLarge?.copyWith(
                fontSize: 30 * widthScale,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8 * heightScale),
            Text(
              'We sent a 4-digit verification code to your email. Please enter it below.',
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 16 * widthScale,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 48 * heightScale),
            Pinput(
              length: 4,
              controller: controller,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: activePinTheme,
              submittedPinTheme: activePinTheme,
              errorPinTheme: errorPinTheme,
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              showCursor: true,
              forceErrorState: hasError,
              onChanged: cubit.otpChange,
            ),
            if (hasError && state.errorMessage != null) ...[
              SizedBox(height: 12 * heightScale),
              Text(
                state.errorMessage!,
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: 12 * widthScale,
                  color: AppColors.error,
                ),
              ),
            ],
            SizedBox(height: 48 * heightScale),
            AppElevatedButton(
              text: 'Verify and Proceed',
              onPressed: state.isLoading ? null : cubit.otpVerify,
            ),
            SizedBox(height: 24 * heightScale),
            AuthActionRow(
              message: "Didn't receive the code? ",
              actionText: "Resend",
              messageColor: AppColors.primary,
              actionColor: AppColors.primary,
              textFontSize: _fontSize(context) * widthScale,
              gap: 4 * widthScale,
              onActionPressed: () {},
            ),
          ],
        );
      },
    );
  }
}