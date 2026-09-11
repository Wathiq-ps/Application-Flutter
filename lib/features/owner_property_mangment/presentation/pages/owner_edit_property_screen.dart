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
import '../../../../core/widget/property_filter_chips.dart';
import '../state_management/owner_property_cubit.dart';
import '../state_management/owner_property_state.dart';
import '../widgets/listing_status_toggle.dart';
import '../widgets/owner_form_input_card.dart';

class OwnerEditPropertyScreen extends StatelessWidget {
  const OwnerEditPropertyScreen({
    super.key,
    required this.property,
  });

  final OwnerPropertyListItem property;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerPropertyCubit(),
      child: _OwnerEditPropertyView(property: property),
    );
  }
}

class _OwnerEditPropertyView extends StatelessWidget {
  const _OwnerEditPropertyView({required this.property});

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
          title: AppStrings.propertyEditedSuccessfully,
          message: '',
          prefixIcon: AppIcons.success,
        );
        context.read<OwnerPropertyCubit>().resetSaveStatus();
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
                            AppStrings.editProperty,
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
                        BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: state.saveStatus ==
                                  OwnerPropertySaveStatus.saving
                                  ? null
                                  : () => context
                                  .read<OwnerPropertyCubit>()
                                  .saveProperty(property.id),
                              child: Text(
                                AppStrings.saveAction,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18 * widthScale,
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 18,
                                  letterSpacing: -0.45,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // ─────────────────────────────────────
                  // Form
                  // ─────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20 * widthScale,
                        8 * heightScale,
                        20 * widthScale,
                        120 * heightScale,
                      ),
                      child: BlocBuilder<OwnerPropertyCubit,
                          OwnerPropertyState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Photos
                              SizedBox(
                                height: 120 * widthScale,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 2,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(width: 7 * widthScale),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width: 220 * widthScale,
                                          height: 120 * widthScale,
                                          decoration: BoxDecoration(
                                            color: AppColors.iconBg,
                                            borderRadius:
                                            BorderRadius.circular(
                                              8 * widthScale,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10 * widthScale,
                                          top: 8 * widthScale,
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              4 * widthScale,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary
                                                  .withValues(alpha: 0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit_outlined,
                                              size: 13 * widthScale,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                              SizedBox(height: 24 * heightScale),

                              // Listing status (active/inactive)
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    property.isListingActive
                                        ? AppStrings.listingActive
                                        : AppStrings.listingInactive,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 14 * widthScale,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.44,
                                    ),
                                  ),
                                  ListingStatusToggle(
                                    isActive: property.isListingActive,
                                    widthScale: widthScale,
                                    onChanged: (_) => context
                                        .read<OwnerPropertyCubit>()
                                        .toggleListingActive(property.id),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16 * heightScale),

                              // Listing type
                              Text(
                                AppStrings.listingType,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12 * widthScale,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              SizedBox(height: 8 * heightScale),
                              PropertyFilterChips(widthScale: widthScale),

                              SizedBox(height: 16 * heightScale),

                              OwnerFormInputCard(
                                label: AppStrings.city,
                                value: property.location,
                                widthScale: widthScale,
                                onEdit: () {},
                              ),

                              SizedBox(height: 16 * heightScale),

                              OwnerFormInputCard(
                                label: AppStrings.propertyType,
                                value: AppStrings.propertyApartment,
                                widthScale: widthScale,
                                onEdit: () {},
                              ),

                              SizedBox(height: 16 * heightScale),

                              OwnerFormInputCard(
                                label: AppStrings.price,
                                value: '${property.price} JOD',
                                widthScale: widthScale,
                                onEdit: () {},
                              ),

                              SizedBox(height: 16 * heightScale),

                              OwnerFormInputCard(
                                label: AppStrings.area,
                                value: '${property.areaSqm} m²',
                                widthScale: widthScale,
                                onEdit: () {},
                              ),

                              SizedBox(height: 16 * heightScale),

                              OwnerFormInputCard(
                                label: AppStrings.features,
                                value:
                                '${property.rooms} Rooms\n${property.bathrooms} Bathrooms',
                                widthScale: widthScale,
                                valueMaxLines: 2,
                                onEdit: () {},
                              ),

                              SizedBox(height: 16 * heightScale),

                              OwnerFormInputCard(
                                label: AppStrings.description,
                                value: AppStrings.descriptionHint,
                                widthScale: widthScale,
                                valueMaxLines: 3,
                                onEdit: () {},
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // ─────────────────────────────────────
              // Sticky bottom action bar
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
                              text: AppStrings.saveAction,
                              onPressed: state.saveStatus ==
                                  OwnerPropertySaveStatus.saving
                                  ? null
                                  : () => context
                                  .read<OwnerPropertyCubit>()
                                  .saveProperty(property.id),
                              backgroundColor: AppColors.primary,
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
                                AppStrings.discardChanges,
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