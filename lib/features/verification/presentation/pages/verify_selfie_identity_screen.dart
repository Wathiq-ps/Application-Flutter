import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../cubit/verification_cubit.dart';
import '../cubit/verification_state.dart';
import '../widgets/identity_area.dart';
import '../widgets/image_source_button.dart';
import '../widgets/requirements_list.dart';
import '../widgets/verification_background.dart';
import '../widgets/verification_card_header.dart';
import '../widgets/verification_glass_card.dart';
import '../widgets/verification_header.dart';
import '../widgets/verification_pending_sheet.dart';
import '../widgets/verificattion_error_listener.dart';

class VerifySelfieIdentityScreen extends StatelessWidget {
  const VerifySelfieIdentityScreen({super.key});

  Future<void> _onSubmitted(BuildContext context) async {
    await VerificationPendingSheet.show(context);
    if (!context.mounted) return;
    context.go(RouteNames.mainNavigation);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;
    final heightScale = context.heightScale;
    final cubit = context.read<VerificationCubit>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocListener<VerificationCubit, VerificationState>(
        listenWhen: (previous, current) =>
        previous.status != current.status &&
            current.status == RequestStatus.success,
        listener: (context, state) => _onSubmitted(context),
        child: VerificationBackground(
          child: VerificationErrorListener(
            child: SafeArea(
              child: Column(
                children: [
                  VerificationHeader(
                    title: AppStrings.verifyYourIdentity,
                    step: AppStrings.step2Of2,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 21.5 * widthScale,
                      ),
                      child: BlocBuilder<VerificationCubit, VerificationState>(
                        buildWhen: (p, c) =>
                        p.selfieImage != c.selfieImage ||
                            p.status != c.status,
                        builder: (context, state) {
                          return Column(
                            children: [
                              VerificationGlassCard(
                                showGlow: true,
                                child: Column(
                                  children: [
                                    VerificationCardHeader(
                                      title: AppStrings.takeSelfieWithId,
                                      subtitle: AppStrings.holdIdNextToFace,
                                      titleFontSize: 24,
                                      titleLineHeight: 32,
                                      titleFontWeight: FontWeight.w600,
                                      titleLetterSpacing: 0,
                                    ),
                                    SizedBox(height: 24 * widthScale),
                                    IdentityUploadArea(
                                      image: state.selfieImage,
                                      onTap: state.isLoading
                                          ? null
                                          : () => cubit.pickSelfieImage(
                                        fromCamera: true,
                                      ),
                                    ),
                                    SizedBox(height: 24 * widthScale),
                                    ImageSourceButtons(
                                      enabled: !state.isLoading,
                                      onCameraPressed: () =>
                                          cubit.pickSelfieImage(
                                            fromCamera: true,
                                          ),
                                      onGalleryPressed: () =>
                                          cubit.pickSelfieImage(
                                            fromCamera: false,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24 * heightScale),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3 * widthScale,
                                ),
                                child: RequirementsList(
                                  circleOpacity: 0.17,
                                  items: [
                                    AppStrings.faceAndIdClearlyVisible,
                                    AppStrings.goodLightingNoShadows,
                                    AppStrings.removeSunglassesOrHats,
                                  ],
                                ),
                              ),
                              SizedBox(height: 24 * heightScale),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      25 * widthScale,
                      8 * heightScale,
                      25 * widthScale,
                      24 * heightScale,
                    ),
                    child: BlocBuilder<VerificationCubit, VerificationState>(
                      buildWhen: (p, c) => p.status != c.status,
                      builder: (context, state) {
                        return AppElevatedButton(
                          text: AppStrings.submit,
                          isLoading: state.isLoading,
                          onPressed: cubit.submitVerification,
                          backgroundColor: AppColors.primary,
                          borderRadius: 9999,
                          elevation: 4,
                          textStyle: textTheme.labelMedium?.copyWith(
                            color: AppColors.white,
                            fontSize: 14 * widthScale,
                            height: 20 / 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}