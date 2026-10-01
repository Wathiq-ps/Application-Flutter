import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/di/injector.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_dialog.dart';
import '../../../../core/widget/app_dropdown_option_tile.dart';
import '../../../../core/widget/app_icon_label_trigger.dart';
import '../../../../core/widget/app_section_row.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/page_header.dart';
import '../../../../core/widget/property_filter_chips.dart';
import '../../domain/entities/owner_property_list_item.dart';
import '../state_management/owner_property_edit_cubit.dart';
import '../state_management/owner_property_edit_state.dart';
import '../widgets/listing_status_toggle.dart';
import '../widgets/owner_features_card.dart';
import '../widgets/owner_form_input_card.dart';
import '../widgets/owner_property_photo_card.dart';

class OwnerEditPropertyScreen extends StatelessWidget {
  const OwnerEditPropertyScreen({super.key, required this.property});

  final OwnerPropertyListItem property;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerPropertyEditCubit(
        property: property,
        repository: Injector.ownerPropertyRepository,
      ),
      child: const _OwnerEditPropertyView(),
    );
  }
}

class _OwnerEditPropertyView extends StatelessWidget {
  const _OwnerEditPropertyView();

  static  Map<String, String> _rentUnitLabels = {
    'per_hour': AppStrings.unitHour,
    'per_day': AppStrings.unitDay,
    'per_week': AppStrings.unitWeek,
    'per_month': AppStrings.unitMonth,
  };

  Future<void> _confirmDiscard(BuildContext context) async {
    final bool? discard = await AppDialog.show<bool>(
      context,
      iconWidth: 64,
      iconHeight: 64,
      icon: AppIcons.circleCloseBlue,
      title: AppStrings.discardChanges,
      message: AppStrings.discardChangesMessage,
      primaryText: AppStrings.discardChanges,
      onPrimary: () => Navigator.of(context).pop(true),
      secondaryText: AppStrings.cancel,
      onSecondary: () => Navigator.of(context).pop(false),
    );

    if (discard == true && context.mounted) context.pop();
  }

  Future<void> _confirmSave(BuildContext context) async {
    final bool? save = await AppDialog.show<bool>(
      context,
      icon: AppIcons.circleEditF,
      iconWidth: 64,
      iconHeight: 64,
      title: AppStrings.editProperty,
      message: AppStrings.sureToEditProperty,
      primaryText: AppStrings.saveAction,
      onPrimary: () => Navigator.of(context).pop(true),
      secondaryText: AppStrings.cancel,
      onSecondary: () => Navigator.of(context).pop(false),
    );

    if (save == true && context.mounted) {
      await context.read<OwnerPropertyEditCubit>().save();
    }
  }

  void _showCurrencySheet(BuildContext context, double widthScale) {
    const List<String> currencies = ['JOD', 'USD', 'ILS'];
    final cubit = context.read<OwnerPropertyEditCubit>();
    final currentCurrency = cubit.state.property.currency;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24 * widthScale)),
          ),
          padding: EdgeInsets.fromLTRB(20 * widthScale, 12 * widthScale, 20 * widthScale, 24 * widthScale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40 * widthScale,
                height: 4 * widthScale,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10 * widthScale),
                ),
              ),
              SizedBox(height: 20 * widthScale),
              Text(
                AppStrings.currency,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18 * widthScale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12 * widthScale),
              ...currencies.map((currency) {
                return AppDropdownOptionTile(
                  widthScale: widthScale,
                  label: currency,
                  isSelected: currency == currentCurrency,
                  onTap: () {
                    cubit.updateCurrency(currency);
                    Navigator.of(sheetContext).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showUnavailable(BuildContext context) {
    AppTopSnackBar.show(
      context,
      title: AppStrings.featureNotAvailable,
      message: AppStrings.featureComingSoon,
      prefixIcon: AppIcons.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 932.0;
    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return BlocListener<OwnerPropertyEditCubit, OwnerPropertyEditState>(
      listenWhen: (previous, current) =>
      previous.saveStatus != current.saveStatus &&
          (current.saveStatus == OwnerPropertySaveStatus.success ||
              current.saveStatus == OwnerPropertySaveStatus.error),
      listener: (context, state) async {
        if (state.saveStatus == OwnerPropertySaveStatus.error) {
          AppTopSnackBar.show(
            context,
            title: AppStrings.saveFailed,
            message: state.errorMessage ?? AppStrings.somethingWentWrong,
            prefixIcon: AppIcons.error,
          );
          context.read<OwnerPropertyEditCubit>().resetSaveStatus();
          return;
        }

        // Success
        final bool review = state.sentToReview;
        final Duration duration = Duration(milliseconds: review ? 2500 : 1500);

        AppTopSnackBar.show(
          context,
          title: review
              ? AppStrings.editSentToReviewTitle
              : AppStrings.propertyEditedSuccessfully,
          message: review ? AppStrings.editSentToReviewMessage : null,
          prefixIcon: AppIcons.success,
          duration: duration,
        );

        await Future.delayed(duration);

        if (context.mounted) context.pop(true); // tell the list to refresh
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
                right: BlocBuilder<OwnerPropertyEditCubit, OwnerPropertyEditState>(
                  buildWhen: (previous, current) => previous.saveStatus != current.saveStatus,
                  builder: (context, state) {
                    final bool isSaving = state.saveStatus == OwnerPropertySaveStatus.saving;
                    return GestureDetector(
                      onTap: isSaving ? null : () => _confirmSave(context),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        AppStrings.saveAction,
                        style: textTheme.bodyLarge?.copyWith(
                          color: isSaving ? AppColors.disabled : theme.colorScheme.onSurface,
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
                padding: EdgeInsets.symmetric(horizontal: 28 * widthScale),
                child: BlocBuilder<OwnerPropertyEditCubit, OwnerPropertyEditState>(
                  buildWhen: (previous, current) => previous.property != current.property,
                  builder: (context, state) {
                    final property = state.property;

                    return Column(
                      children: [
                        SizedBox(height: 40 * widthScale),
                        AppSectionRow(
                          widthScale: widthScale,
                          label: AppStrings.statusProperty,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          lineHeight: 1.0,
                          letterSpacing: 0.44,
                          trailing: ListingStatusToggle(
                            isActive: property.isListingActive,
                            widthScale: widthScale,
                            onChanged: (_) =>
                                context.read<OwnerPropertyEditCubit>().toggleListingActive(),
                          ),
                        ),
                        SizedBox(height: 25 * widthScale),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3 * widthScale),
                          child: AppSectionRow(
                            widthScale: widthScale,
                            label: AppStrings.photo,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.0,
                            letterSpacing: 0.44,
                            trailing: AppLabelIconTrigger(
                              widthScale: widthScale,
                              label: AppStrings.editAction,
                              fontSize: 12 * heightScale,
                              fontWeight: FontWeight.w500,
                              icon: AppIcons.edit,
                              switchIconText: true,
                              iconHeight: 12 * widthScale,
                              iconWidth: 16 * widthScale,
                              onTap: () => _showUnavailable(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: 12 * widthScale),

              Expanded(
                child: BlocBuilder<OwnerPropertyEditCubit, OwnerPropertyEditState>(
                  buildWhen: (previous, current) => previous.property != current.property,
                  builder: (context, state) {
                    final property = state.property;
                    final cubit = context.read<OwnerPropertyEditCubit>();
                    final bool isRent = property.listingType == 'rent';

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
                            separatorBuilder: (_, __) => SizedBox(width: 7 * widthScale),
                            itemBuilder: (context, index) {
                              return OwnerPropertyPhotoCard(
                                widthScale: widthScale,
                                imageUrl: ImagePath.villa,
                                icon: AppIcons.circleCloseBlue,
                                onEdit: () {
                                  // TODO: replace photo at [index].
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Listing type
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
                                  selectedIndex: isRent ? 1 : 0,
                                  onChanged: (index) =>
                                      cubit.updateListingType(index == 1 ? 'rent' : 'sale'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Property type
                        OwnerFormInputCard(
                          label: AppStrings.propertyType,
                          value: property.propertyType,
                          actionIcon: AppIcons.edit,
                          suffixIcon: AppIcons.arrowDownAshen,
                          suffixIconHeight: 8,
                          suffixIconWidth: 6,
                          widthScale: widthScale,
                          dropdownOptions:  [
                            AppStrings.propertyApartment,
                            AppStrings.propertyVilla,
                            AppStrings.propertyLand,
                            AppStrings.propertyShop,
                            AppStrings.propertyHouse,
                          ],
                          otherOptionLabel: AppStrings.propertyOther,
                          onDropdownSelected: cubit.updatePropertyType,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Location (read-only)
                        OwnerFormInputCard(
                          label: AppStrings.location,
                          value: property.location,
                          actionLabel: AppStrings.changeOnMap,
                          actionIcon: AppIcons.viewOnMap,
                          actionIconHeight: 10.5 * widthScale,
                          actionIconWidth: 10.5 * widthScale,
                          switchIconText: false,
                          widthScale: widthScale,
                          isEditable: false,
                          onEdit: () => _showUnavailable(context),
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Price
                        OwnerFormInputCard(
                          label: AppStrings.price,
                          value: property.price,
                          suffixWidget: AppLabelIconTrigger(
                            widthScale: widthScale,
                            label: property.currency,
                            icon: AppIcons.arrowDownAshen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            iconWidth: 7,
                            iconHeight: 5,
                            gap: 4,
                            onTap: () => _showCurrencySheet(context, widthScale),
                          ),
                          actionIcon: AppIcons.edit,
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                          isEditable: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onValueChanged: cubit.updatePrice,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Price unit (rent only)
                        if (isRent) ...[
                          OwnerFormInputCard(
                            label: AppStrings.priceUnit,
                            value: _rentUnitLabels[property.rentUnit] ??
                                AppStrings.selectPriceUnit,
                            actionIcon: AppIcons.edit,
                            suffixIcon: AppIcons.arrowDownAshen,
                            suffixIconHeight: 8,
                            suffixIconWidth: 6,
                            widthScale: widthScale,
                            dropdownSheetTitle: AppStrings.selectPriceUnit,
                            dropdownOptions: _rentUnitLabels.values.toList(),
                            enableOtherCustomInput: false,
                            onDropdownSelected: (selected) {
                              final entry = _rentUnitLabels.entries
                                  .where((e) => e.value == selected)
                                  .toList();
                              if (entry.isNotEmpty) {
                                cubit.updateRentUnit(entry.first.key);
                              }
                            },
                          ),
                          SizedBox(height: 16 * heightScale),
                        ],

                        // Area
                        OwnerFormInputCard(
                          label: AppStrings.area,
                          value: '${property.areaSqm}',
                          suffixText: 'm²',
                          actionIcon: AppIcons.edit,
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                          isEditable: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          onValueChanged: cubit.updateArea,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Rooms
                        OwnerFormInputCard(
                          label: AppStrings.rooms,
                          value: '${property.rooms}',
                          actionIcon: AppIcons.edit,
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                          isEditable: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onValueChanged: cubit.updateRooms,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Bathrooms
                        OwnerFormInputCard(
                          label: AppStrings.bathrooms,
                          value: '${property.bathrooms}',
                          actionIcon: AppIcons.edit,
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                          isEditable: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onValueChanged: cubit.updateBathrooms,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Floor
                        OwnerFormInputCard(
                          label: AppStrings.floor,
                          value: property.floorNumber?.toString() ?? '-',
                          actionIcon: AppIcons.edit,
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                          isEditable: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onValueChanged: cubit.updateFloor,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Furnished
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3 * widthScale),
                          child: AppSectionRow(
                            widthScale: widthScale,
                            label: AppStrings.furnished,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.0,
                            letterSpacing: 0.44,
                            trailing: ListingStatusToggle(
                              isActive: property.isFurnished,
                              widthScale: widthScale,
                              onChanged: cubit.updateFurnished,
                            ),
                          ),
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Features
                        OwnerFeaturesCard(
                          selected: property.features,
                          widthScale: widthScale,
                          onChanged: cubit.updateFeatures,
                        ),
                        SizedBox(height: 16 * heightScale),

                        // Description
                        OwnerFormInputCard(
                          label: AppStrings.description,
                          value: property.description,
                          actionIcon: AppIcons.edit,
                          widthScale: widthScale,
                          valueMaxLines: 3,
                          isEditable: true,
                          onValueChanged: cubit.updateDescription,
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