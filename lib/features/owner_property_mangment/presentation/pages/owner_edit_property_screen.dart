import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_dialog.dart';
import '../../../../core/widget/app_section_row.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/page_header.dart';
import '../../../../core/widget/property_filter_chips.dart';
import '../../domain/entities/owner_property_list_item.dart';
import '../state_management/owner_property_cubit.dart';
import '../state_management/owner_property_state.dart';
import '../widgets/listing_status_toggle.dart';
import '../widgets/owner_form_input_card.dart';
import '../widgets/owner_property_photo_card.dart';

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

  // ─────────────────────────────────────
  // Discard confirmation
  // ─────────────────────────────────────
  Future<void> _confirmDiscard(BuildContext context) async {
    final bool? discard = await AppDialog.show<bool>(
      context,
      title: AppStrings.discardChanges,
      message: AppStrings.discardChangesMessage,
      primaryText: AppStrings.discardChanges,
      onPrimary: () => Navigator.of(context).pop(true),
      secondaryText: AppStrings.cancel,
      onSecondary: () => Navigator.of(context).pop(false),
    );

    if (discard == true && context.mounted) {
      context.pop();
    }
  }

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
      listener: (context, state) async {
        AppTopSnackBar.show(
          context,
          title: AppStrings.propertyEditedSuccessfully,
          message: '',
          prefixIcon: AppIcons.success,
          duration: const Duration(milliseconds: 1500),
        );

        context.read<OwnerPropertyCubit>().resetSaveStatus();

        await Future.delayed(const Duration(milliseconds: 1500));
        if (context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ─────────────────────────────────────
              // Header: back • title • save
              // ─────────────────────────────────────
              PageHeader(
                widthScale: widthScale,
                expandCenter: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 20 * widthScale,
                  vertical: 12 * heightScale,
                ),
                left: AppSvgIconButton(
                  widthScale: widthScale,
                  icon: AppIcons.backArrowProp,
                  iconWidth: 20,
                  iconHeight: 16,
                  onTap: () => _confirmDiscard(context),
                ),
                center: Text(
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
                right: BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
                  buildWhen: (p, c) => p.saveStatus != c.saveStatus,
                  builder: (context, state) {
                    final bool isSaving =
                        state.saveStatus == OwnerPropertySaveStatus.saving;

                    return GestureDetector(
                      onTap: isSaving
                          ? null
                          : () => context
                          .read<OwnerPropertyCubit>()
                          .saveProperty(property.id),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        AppStrings.saveAction,
                        style: TextStyle(
                          color: isSaving
                              ? AppColors.disabled
                              : AppColors.textPrimary,
                          fontSize: 18 * widthScale,
                          fontWeight: FontWeight.w500,
                          height: 24 / 18,
                          letterSpacing: -0.45,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ─────────────────────────────────────
              // Form (single scrollable ListView)
              // ─────────────────────────────────────
              Expanded(
                child: BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
                  builder: (context, state) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        20 * widthScale,
                        8 * heightScale,
                        20 * widthScale,
                        32 * heightScale,
                      ),
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
                              return OwnerPropertyPhotoCard(
                                widthScale: widthScale,
                                onEdit: () {
                                  // TODO: replace photo at [index].
                                },
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 24 * heightScale),

                        // Listing status (active / inactive)
                        AppSectionRow(
                          widthScale: widthScale,
                          label: property.isListingActive
                              ? AppStrings.listingActive
                              : AppStrings.listingInactive,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          lineHeight: 1.0,
                          letterSpacing: 0.44,
                          trailing: ListingStatusToggle(
                            isActive: property.isListingActive,
                            widthScale: widthScale,
                            onChanged: (_) => context
                                .read<OwnerPropertyCubit>()
                                .toggleListingActive(property.id),
                          ),
                        ),

                        SizedBox(height: 16 * heightScale),

                        // Listing type + chips on one row
                        AppSectionRow(
                          widthScale: widthScale,
                          label: AppStrings.listingType,
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          lineHeight: 1.0,
                          letterSpacing: 0.24,
                          expandLabel: false,
                          gap: 12,
                          trailing: Flexible(
                            child: PropertyFilterChips(widthScale: widthScale),
                          ),
                        ),

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
            ],
          ),
        ),
      ),
    );
  }
}