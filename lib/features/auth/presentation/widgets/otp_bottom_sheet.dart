import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/constant/strings.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import 'package:mobile/core/widget/app_button.dart';
import 'package:mobile/core/widget/app_top_snackbar.dart';
import 'package:pinput/pinput.dart';

import '../state_mangement/cubit/auth_cubit.dart';
import '../state_mangement/cubit/auth_state.dart';
import 'auth_action_row.dart';
import 'otp_success.dart';

class OtpBottomSheet extends StatefulWidget {
  const OtpBottomSheet({super.key});

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();

  Timer? _autoCloseTimer;

  static const Duration _autoCloseDuration = Duration(seconds: 4);

  @override
  void dispose() {
    _otpController.dispose();
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  void _scheduleAutoClose() {
    _autoCloseTimer?.cancel();

    _autoCloseTimer = Timer(_autoCloseDuration, () {
      if (!mounted) return;

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final widthScale = context.screenWidth / _OtpForm.figmaWidth;

    return Padding(
      padding: EdgeInsets.only(
        bottom: context.keyboardBottomInset,
      ),
      child: Container(
        padding: EdgeInsets.all(24 * widthScale),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35 * widthScale),
          ),
        ),
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
          previous.status != current.status,
          listener: (context, state) {
            if (state.status == AuthStatus.otpBackendError &&
                state.errorMessage != null) {
              AppTopSnackBar.show(
                context,
                title: AppStrings.verificationFailed,
                message: state.errorMessage!,
                prefixIcon: AppIcons.error,
              );
            } else if (state.status == AuthStatus.otpVerified) {
              _scheduleAutoClose();
            }
          },
          buildWhen: (previous, current) =>
          previous.status != current.status,
          builder: (context, state) {
            if (state.status == AuthStatus.otpVerified) {
              return const OtpSuccessView();
            }

            return _OtpForm(
              controller: _otpController,
            );
          },
        ),
      ),
    );
  }
}

class _OtpForm extends StatelessWidget {
  const _OtpForm({
    required this.controller,
  });

  final TextEditingController controller;

  static const double figmaWidth = 393;
  static const double _figmaHeight = 852;

  static const int _otpLength = 6;

  double _fontSize(BuildContext context) {
    if (context.screenHeight > 1020) {
      return 10;
    }

    return 14;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<AuthCubit>();
    final state = context.watch<AuthCubit>().state;

    final widthScale = context.screenWidth / figmaWidth;
    final heightScale = context.screenHeight / _figmaHeight;

    final defaultPinTheme = PinTheme(
      width: 48 * widthScale,
      height: 56 * heightScale,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border,
        ),
        borderRadius: BorderRadius.circular(
          10 * widthScale,
        ),
      ),
    );

    final activePinTheme = PinTheme(
      textStyle: textTheme.headlineLarge?.copyWith(
        fontSize: 24 * widthScale,
        color: AppColors.primary,
      ),
      width: 48 * widthScale,
      height: 56 * heightScale,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(
          10 * widthScale,
        ),
      ),
    );

    final errorPinTheme = PinTheme(
      textStyle: textTheme.headlineLarge?.copyWith(
        fontSize: 24 * widthScale,
        color: AppColors.primary,
      ),
      width: 48 * widthScale,
      height: 56 * heightScale,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.error,
        ),
        borderRadius: BorderRadius.circular(
          10 * widthScale,
        ),
      ),
    );

    final hasError =
        state.status == AuthStatus.otpValidationError ||
            state.status == AuthStatus.otpBackendError;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.enterCode,
          style: textTheme.headlineLarge?.copyWith(
            fontSize: 30 * widthScale,
            color: AppColors.primary,
          ),
        ),
        SizedBox(
          height: 8 * heightScale,
        ),
        Text(
          AppStrings.otpVerificationInstruction,
          style: textTheme.bodyLarge?.copyWith(
            fontSize: 16 * widthScale,
            color: AppColors.primary,
          ),
        ),
        SizedBox(
          height: 48 * heightScale,
        ),
        Pinput(
          length: _otpLength,
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
          SizedBox(
            height: 12 * heightScale,
          ),
          Text(
            state.errorMessage!,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 12 * widthScale,
              color: AppColors.error,
            ),
          ),
        ],
        SizedBox(
          height: 48 * heightScale,
        ),
        AppElevatedButton(
          text: AppStrings.verifyAndProceed,
          onPressed: state.isLoading ? null : cubit.otpVerify,
        ),
        SizedBox(
          height: 24 * heightScale,
        ),
        AuthActionRow(
          message: AppStrings.didntReceiveCode,
          actionText: AppStrings.resend,
          messageColor: AppColors.primary,
          actionColor: AppColors.primary,
          textFontSize: _fontSize(context) * widthScale,
          gap: 4 * widthScale,
          onActionPressed: () {},
        ),
      ],
    );
  }
}