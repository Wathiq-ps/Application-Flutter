import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../cubit/verification_cubit.dart';
import '../cubit/verification_state.dart';
import '../widgets/identity_area.dart';
import '../widgets/image_source_button.dart';
import '../widgets/requirements_list.dart';
import '../widgets/verification_background.dart';
import '../widgets/verification_card_header.dart';
import '../widgets/verification_glass_card.dart';
import '../widgets/verification_header.dart';
import '../widgets/verificattion_error_listener.dart';

class VerifyIdentityScreen extends StatelessWidget {
  const VerifyIdentityScreen({super.key});

  void _continue(BuildContext context) {
    if (context.read<VerificationCubit>().state.idImage == null) {
      AppTopSnackBar.show(
        context,
        title: AppStrings.verificationFailed,
        message: AppStrings.pleaseUploadIdFirst,
        prefixIcon: AppIcons.error,
      );
      return;
    }
    context.push(RouteNames.verifySelfieIdentityScreen);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;
    final heightScale = context.heightScale;
    final cubit = context.read<VerificationCubit>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: VerificationBackground(
        child: VerificationErrorListener(
          child: SafeArea(
            child: Column(
              children: [
                VerificationHeader(
                  title: AppStrings.verifyYourIdentity,
                  step: AppStrings.step1Of2,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 21.5 * widthScale,
                    ),
                    child: BlocBuilder<VerificationCubit, VerificationState>(
                      buildWhen: (p, c) => p.idImage != c.idImage,
                      builder: (context, state) {
                        return Column(
                          children: [
                            VerificationGlassCard(
                              child: Column(
                                children: [
                                  VerificationCardHeader(
                                    title: AppStrings.uploadYourId,
                                    subtitle: AppStrings.takeClearPhotoOfId,
                                  ),
                                  SizedBox(height: 24 * widthScale),
                                  IdentityUploadArea(
                                    image: state.idImage,
                                    onTap: () => cubit.pickIdImage(
                                      fromCamera: false,
                                    ),
                                  ),
                                  SizedBox(height: 24 * widthScale),
                                  ImageSourceButtons(
                                    onCameraPressed: () => cubit.pickIdImage(
                                      fromCamera: true,
                                    ),
                                    onGalleryPressed: () => cubit.pickIdImage(
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
                                items: [
                                  AppStrings.allFourCornersVisible,
                                  AppStrings.noGlareOrBlur,
                                  AppStrings.textIsReadable,
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
                  child: AppElevatedButton(
                    text: AppStrings.continueText,
                    onPressed: () => _continue(context),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}