import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/widget/app_svg_button.dart';
import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_section_row.dart';
import '../../../../core/widget/page_header.dart';
import '../../../../core/widget/property_card.dart';
import '../state_management/owner_property_cubit.dart';
import '../state_management/owner_property_state.dart';
import '../widgets/app_icon_label_trigger.dart';

class OwnerPropertiesScreen extends StatelessWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 852.0;

    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;

    return BlocProvider(
      create: (_) => OwnerPropertyCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
            builder: (context, state) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 23 * widthScale),
                itemCount: state.properties.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageHeader(
                          widthScale: widthScale,
                          leftGap: 30 * widthScale,
                          left: AppSvgIconButton(
                              widthScale: widthScale,
                            icon: AppIcons.backArrowProp ,
                            iconWidth: 16
                            ,iconHeight: 16,onTap: (){

                          },),
                          center: Text(
                            AppStrings.myProperties,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18 * widthScale,
                              fontWeight: FontWeight.w500,
                              height: 24 / 18,
                              letterSpacing: -0.45,
                            ),
                          ),
                          right: AppElevatedButton(
                            text: AppStrings.addNewProperty,
                            onPressed: () {
                              // TODO: navigate to add-property flow.
                            },
                            width: 97 * widthScale,
                            height: 32 * widthScale,
                            backgroundColor: AppColors.primary,
                            borderRadius: 9999,
                            elevation: 0,
                            preIcon: SvgPicture.asset(AppIcons.plus),
                            iconSize: 10 * widthScale,
                            iconGap: 4 * widthScale,
                            textStyle: TextStyle(
                              color: AppColors.white,
                              fontSize: 12 * widthScale,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.24,
                            ),
                          ),
                        ),
                        SizedBox(height: 24 * heightScale),
                        AppSectionRow(
                          widthScale: widthScale,
                          label: '${state.properties.length} ${AppStrings.propertiesListedCount}',
                          trailing: AppLabelIconTrigger(
                            widthScale: widthScale,
                            label: AppStrings.allStatus,
                            icon: AppIcons.arrowDownBlue,
                            onTap: () {
                              // TODO: open status filter.
                            },
                          ),
                        ),
                        SizedBox(height: 16 * heightScale),
                      ],
                    );
                  }
                  if (index == state.properties.length + 1) {
                    return SizedBox(height: 40 * heightScale);
                  }
                  final propertyIndex = index - 1;
                  final property = state.properties[propertyIndex];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: propertyIndex == state.properties.length - 1
                          ? 0
                          : 16 * heightScale,
                    ),
                    child: PropertyCard(
                      property: property,
                      widthScale: widthScale,
                      showStatus: true,
                      propMang: true,
                      onViewDetails: () {
                        // TODO: navigate to details screen once it exists.
                      },
                      onEdit: () {
                        context.push(
                          RouteNames.ownerEditPropertyScreen,
                          extra: property,
                        );
                      },
                      onDelete: () {
                        context.push(
                          RouteNames.ownerDeletePropertyScreen,
                          extra: property,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}