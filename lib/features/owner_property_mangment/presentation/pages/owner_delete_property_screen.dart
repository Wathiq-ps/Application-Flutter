import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../state_management/owner_property_cubit.dart';
import '../state_management/owner_property_state.dart';

class OwnerDeletePropertyScreen extends StatelessWidget {
  const OwnerDeletePropertyScreen({
    super.key,
    required this.property,
  });

  final OwnerPropertyListItem property;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerPropertyCubit(),
      child: _OwnerDeletePropertyView(property: property),
    );
  }
}

class _OwnerDeletePropertyView extends StatelessWidget {
  const _OwnerDeletePropertyView({required this.property});

  final OwnerPropertyListItem property;

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 932.0;

    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;

    return BlocListener<OwnerPropertyCubit, OwnerPropertyState>(
      listenWhen: (previous, current) =>
      previous.saveStatus != current.saveStatus &&
          current.saveStatus == OwnerPropertySaveStatus.success,
      listener: (context, state) {
        AppTopSnackBar.show(
          context,
          title: AppStrings.propertyDeletedSuccessfully,
          message: '',
          prefixIcon: AppIcons.success,
          onClose: () => context.pop(),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // ─────────────────────────────────────
                  // Header
                  // ─────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20 * widthScale,
                      vertical: 12 * heightScale,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            AppIcons.back,
                            width: 20 * widthScale,
                            height: 16 * widthScale,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.deleteProperty,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18 * widthScale,
                              fontWeight: FontWeight.w500,
                              height: 24 / 18,
                              letterSpacing: -0.45,
                            ),
                          ),
                        ),
                        Text(
                          AppStrings.deleteAction,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 18 * widthScale,
                            fontWeight: FontWeight.w500,
                            height: 24 / 18,
                            letterSpacing: -0.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ─────────────────────────────────────
                  // Warning content
                  // ─────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20 * widthScale,
                        24 * heightScale,
                        20 * widthScale,
                        120 * heightScale,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 220 * widthScale,
                            height: 120 * widthScale,
                            decoration: BoxDecoration(
                              color: AppColors.iconBg,
                              borderRadius:
                              BorderRadius.circular(8 * widthScale),
                            ),
                          ),

                          SizedBox(height: 20 * heightScale),

                          Text(
                            property.title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18 * widthScale,
                              fontWeight: FontWeight.w600,
                              height: 24 / 18,
                              letterSpacing: -0.45,
                            ),
                          ),

                          SizedBox(height: 12 * heightScale),

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14 * widthScale),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(
                                alpha: 0.06,
                              ),
                              borderRadius:
                              BorderRadius.circular(16 * widthScale),
                              border: Border.all(
                                color: AppColors.error.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.deletePropertyWarning,
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 13 * widthScale,
                                fontWeight: FontWeight.w400,
                                height: 20 / 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ─────────────────────────────────────
              // Sticky delete bar
              // ─────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * widthScale,
                    vertical: 12 * heightScale,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A1F44).withValues(
                          alpha: 0.08,
                        ),
                        offset: const Offset(0, -8),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: BlocBuilder<OwnerPropertyCubit,
                        OwnerPropertyState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppElevatedButton(
                              text: AppStrings.deleteThisProperty,
                              onPressed: state.saveStatus ==
                                  OwnerPropertySaveStatus.saving
                                  ? null
                                  : () => context
                                  .read<OwnerPropertyCubit>()
                                  .deleteProperty(property.id),
                              backgroundColor: AppColors.error,
                              height: 48 * widthScale,
                              borderRadius: 9999,
                              textStyle: TextStyle(
                                color: AppColors.white,
                                fontSize: 14 * widthScale,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8 * heightScale),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                AppStrings.cancelAction,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 11 * widthScale,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.44,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}