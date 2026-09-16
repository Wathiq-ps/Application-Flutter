import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constant/images_path.dart';
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
import '../widgets/app_icon_label_trigger.dart';
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
      child: _OwnerEditPropertyView(
        property: property,
      ),
    );
  }
}

class _OwnerEditPropertyView extends StatelessWidget {
  const _OwnerEditPropertyView({
    required this.property,
  });

  final OwnerPropertyListItem property;

  Future<void> _confirmDiscard(BuildContext context) async {
    final bool? discard = await AppDialog.show<bool>(
      context,
      title: AppStrings.discardChanges,
      message: AppStrings.discardChangesMessage,
      primaryText: AppStrings.discardChanges,
      onPrimary: () {
        Navigator.of(context).pop(true);
      },
      secondaryText: AppStrings.cancel,
      onSecondary: () {
        Navigator.of(context).pop(false);
      },
    );

    if (discard == true && context.mounted) {
      context.pop();
    }
  }

  Future<void> _confirmSave(BuildContext context) async {
    final bool? save = await AppDialog.show<bool>(
      context,
      title: AppStrings.saveChanges,
      message: AppStrings.saveChangesMessage,
      primaryText: AppStrings.saveAction,
      onPrimary: () {
        Navigator.of(context).pop(true);
      },
      secondaryText: AppStrings.cancel,
      onSecondary: () {
        Navigator.of(context).pop(false);
      },
    );

    if (save == true && context.mounted) {
      await context.read<OwnerPropertyCubit>().saveProperty(
        property.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 932.0;

    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

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
          duration: const Duration(
            milliseconds: 1500,
          ),
        );

        context.read<OwnerPropertyCubit>().resetSaveStatus();

        await Future.delayed(
          const Duration(
            milliseconds: 1500,
          ),
        );

        if (context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
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
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w500,
                    height: 24 / 18,
                    letterSpacing: -0.45,
                  ),
                ),
                right: BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
                  buildWhen: (previous, current) =>
                  previous.saveStatus != current.saveStatus,
                  builder: (context, state) {
                    final bool isSaving =
                        state.saveStatus ==
                            OwnerPropertySaveStatus.saving;

                    return GestureDetector(
                      onTap: isSaving
                          ? null
                          : () => _confirmSave(context),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        AppStrings.saveAction,
                        style: textTheme.bodyLarge?.copyWith(
                          color: isSaving
                              ? AppColors.disabled
                              : theme.colorScheme.onSurface,
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
              Padding(
                padding:  EdgeInsets.symmetric(horizontal : 28 * widthScale),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40 * widthScale,
                    ),


                    AppSectionRow(
                      widthScale: widthScale,
                      label: AppStrings.statusProperty,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      lineHeight: 1.0,
                      letterSpacing: 0.44,
                      trailing: ListingStatusToggle(
                        isActive:false,
                        widthScale: widthScale,
                        onChanged: (_) {
                          context
                              .read<OwnerPropertyCubit>()
                              .toggleListingActive(
                            property.id,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 25 * widthScale,),

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 3 * widthScale),

                      child: AppSectionRow(
                        widthScale: widthScale,
                        label: AppStrings.photo,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        lineHeight: 1.0,
                        letterSpacing: 0.44,
                        /// TODO : add switch between both icon and label
                        trailing: AppLabelIconTrigger(
                          widthScale: widthScale,
                          label: AppStrings.editAction,
                          fontSize: 12 * heightScale,
                          fontWeight:FontWeight.w500 ,
                          icon: AppIcons.edit,
                          iconHeight: 12 * widthScale,
                          iconWidth: 16 * widthScale,
                          onTap: () {
                            // TODO: open status filter.
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12 * widthScale,),
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
                        SizedBox(
                          height: 120 * widthScale,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            separatorBuilder: (_, __) => SizedBox(
                              width: 7 * widthScale,
                            ),
                            itemBuilder: (context, index) {
                              return OwnerPropertyPhotoCard(
                                widthScale: widthScale,
                                imageUrl: ImagePath.villa,
                                icon:  AppIcons.circleCloseBlue,
                                onEdit: () {
// TODO: Replace photo at [index].
                                },
                              );
                            },
                          ),
                        ),


                        SizedBox(
                          height: 16 * heightScale,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.listingType,
                                style: TextStyle(
                                  fontSize: 12 * widthScale,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.24 * widthScale,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(width: 45 * widthScale),
                              Expanded(
                                child: PropertyFilterChips(
                                  widthScale: widthScale,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 16 * heightScale,
                        ),


                        OwnerFormInputCard(
                          label: AppStrings.city,
                          value: property.location,
                          widthScale: widthScale,
                          icon: AppIcons.edit,
                          onEdit: () {},
                        ),

                        SizedBox(
                          height: 16 * heightScale,
                        ),


                        OwnerFormInputCard(
                          label: AppStrings.propertyType,
                          value: AppStrings.propertyApartment,
                          icon: AppIcons.edit,
                          widthScale: widthScale,
                          onEdit: () {},
                        ),

                        SizedBox(
                          height: 16 * heightScale,
                        ),

                        OwnerFormInputCard(
                          label: AppStrings.price,
                          value: '${property.price} JOD',
                          widthScale: widthScale,
                          icon: AppIcons.edit,
                          onEdit: () {},
                        ),

                        SizedBox(
                          height: 16 * heightScale,
                        ),

                        OwnerFormInputCard(
                          label: AppStrings.area,
                          value: '${property.areaSqm} m²',
                          icon: AppIcons.edit,
                          widthScale: widthScale,
                          onEdit: () {},
                        ),

                        SizedBox(
                          height: 16 * heightScale,
                        ),

                        OwnerFormInputCard(
                          label: AppStrings.features,
                          value:
                          '${property.rooms} Rooms\n'
                              '${property.bathrooms} Bathrooms',
                          widthScale: widthScale,
                          icon: AppIcons.edit,
                          valueMaxLines: 2,
                          onEdit: () {},
                        ),

                        SizedBox(
                          height: 16 * heightScale,
                        ),

                        OwnerFormInputCard(
                          label: AppStrings.description,
                          value: AppStrings.descriptionHint,
                          icon: AppIcons.edit,
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
