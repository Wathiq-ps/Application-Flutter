import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constant/images_path.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_dialog.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/page_header.dart';
import '../../domain/entities/owner_property_list_item.dart';
import '../state_management/owner_property_cubit.dart';
import '../state_management/owner_property_state.dart';
import '../widgets/owner_form_input_card.dart';
import '../widgets/owner_property_photo_card.dart';

class OwnerDeletePropertyScreen extends StatelessWidget {
  const OwnerDeletePropertyScreen({
    super.key,
    required this.property,
  });

  final OwnerPropertyListItem property;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerPropertyCubit.forEdit(
        property: property,
      ),
      child: _OwnerDeletePropertyView(
        property: property,
      ),
    );
  }
}

class _OwnerDeletePropertyView extends StatelessWidget {
  const _OwnerDeletePropertyView({
    required this.property,
  });

  final OwnerPropertyListItem property;

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? delete = await AppDialog.show<bool>(
      context,
      icon: AppIcons.errorDialog,
      iconWidth: 26,
      iconHeight: 22,
      title: AppStrings.deleteProperty,
      message: AppStrings.sureToDeleteProperty,
      primaryText: AppStrings.deleteAction,
      primaryBackgroundColor: AppColors.error,
      onPrimary: () {
        Navigator.of(context).pop(true);
      },
      secondaryText: AppStrings.cancel,
      onSecondary: () {
        Navigator.of(context).pop(false);
      },
    );

    if (delete == true && context.mounted) {
      await context.read<OwnerPropertyCubit>().deleteProperty(
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
          title: AppStrings.propertyDeletedSuccessfully,
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
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // ─────────────────────────────────────
              // Header: back • title • delete
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
                  onTap: () => context.pop(),
                ),
                center: Text(
                  AppStrings.deleteProperty,
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
                    final bool isDeleting =
                        state.saveStatus == OwnerPropertySaveStatus.saving;

                    return GestureDetector(
                      onTap: isDeleting ? null : () => _confirmDelete(context),
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        AppStrings.deleteAction,
                        style: textTheme.bodyLarge?.copyWith(
                          color: isDeleting
                              ? AppColors.disabled
                              : AppColors.error,
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

              SizedBox(height: 12 * widthScale),


              Expanded(
                child: BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
                  buildWhen: (previous, current) =>
                  previous.properties != current.properties,
                  builder: (context, state) {
                    final OwnerPropertyListItem currentProperty =
                    state.properties.firstWhere(
                          (item) => item.id == property.id,
                      orElse: () => property,
                    );

                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        20 * widthScale,
                        8 * heightScale,
                        20 * widthScale,
                        32 * heightScale,
                      ),
                      children: [
                        // Photos (view-only — no edit badge overlay).
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
                                imageUrl: ImagePath.villa,
                                showEditBadge: false,
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 16 * heightScale),

                        OwnerFormInputCard(
                          label: AppStrings.propertyType,
                          value: currentProperty.propertyType,
                          widthScale: widthScale,
                        ),

                        SizedBox(height: 16 * heightScale),

                        OwnerFormInputCard(
                          label: AppStrings.location,
                          value: currentProperty.location,
                          widthScale: widthScale,
                        ),

                        SizedBox(height: 16 * heightScale),

                        OwnerFormInputCard(
                          label: AppStrings.price,
                          value: currentProperty.price,
                          suffixText: currentProperty.currency,
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                        ),

                        SizedBox(height: 16 * heightScale),

                        OwnerFormInputCard(
                          label: AppStrings.area,
                          value: '${currentProperty.areaSqm}',
                          suffixText: 'm²',
                          widthScale: widthScale,
                          valueFontSize: 16,
                          valueFontWeight: FontWeight.w700,
                        ),

                        SizedBox(height: 16 * heightScale),

                        OwnerFormInputCard(
                          label: AppStrings.features,
                          value: '${currentProperty.rooms} Rooms\n'
                              '${currentProperty.bathrooms} Bathrooms',
                          widthScale: widthScale,
                          valueMaxLines: 2,
                        ),

                        SizedBox(height: 16 * heightScale),

                        OwnerFormInputCard(
                          label: AppStrings.description,
                          value: currentProperty.description,
                          widthScale: widthScale,
                          valueMaxLines: 3,
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