import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../data/models/verification_model.dart';
import '../cubit/verification_cubit.dart';
import '../cubit/verification_state.dart';
import '../widgets/verification_background.dart';
import '../widgets/verification_status_card.dart';
import '../widgets/verificattion_error_listener.dart';

class VerificationPendingScreen extends StatefulWidget {
  const VerificationPendingScreen({super.key});

  @override
  State<VerificationPendingScreen> createState() =>
      _VerificationPendingScreenState();
}

class _VerificationPendingScreenState extends State<VerificationPendingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VerificationCubit>().getVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    final widthScale = context.widthScale;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<VerificationCubit, VerificationState>(
        listenWhen: (previous, current) =>
        previous.verification?.status != current.verification?.status,
        listener: (context, state) {
          if (state.verification?.status == VerificationStatus.approved) {
            context.go(RouteNames.lsitpro);
          }
        },
        child: VerificationErrorListener(
          child: VerificationBackground(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<VerificationCubit, VerificationState>(
                builder: (context, state) {
                  final isRejected =
                      state.verification?.status == VerificationStatus.rejected;
                  final cubit = context.read<VerificationCubit>();

                  return VerificationStatusCard(
                    icon: state.isLoading
                        ? SizedBox(
                      width: 32 * widthScale,
                      height: 32 * widthScale,
                      child: const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                    )
                        : isRejected
                        ? Icon(
                      Icons.close_rounded,
                      color: AppColors.primary,
                      size: 40 * widthScale,
                    )
                        : SizedBox(
                      width: 80 * widthScale,
                      height: 80 * widthScale,
                      child: Lottie.asset(
                        ImagePath.minimalClock,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: isRejected
                        ? AppStrings.verificationRejected
                        : AppStrings.verificationPending,
                    message: isRejected
                        ? AppStrings.verificationRejectedDescription
                        : AppStrings.verificationPendingDescription,
                    buttonText: isRejected
                        ? AppStrings.tryAgain
                        : AppStrings.backToHome,
                    onButtonPressed: () {
                      if (isRejected) {
                        cubit.reset();
                        context.go(RouteNames.verifyIdentityScreen);
                      } else {
                        context.go(RouteNames.mainNavigation);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}