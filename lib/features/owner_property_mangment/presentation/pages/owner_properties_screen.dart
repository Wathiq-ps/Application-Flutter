import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/widget/app_svg_button.dart';
import 'package:mobile/core/widget/empty_state_view.dart';
import 'package:mobile/core/widget/error_retry_view.dart';
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
import '../../../../core/widget/app_icon_label_trigger.dart';

class OwnerPropertiesScreen extends StatelessWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 852.0;
    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;

    return BlocProvider(
      create: (_) => OwnerPropertyCubit(Injector.ownerPropertyRepository)..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Builder(
            builder: (context) {
              final cubit = context.read<OwnerPropertyCubit>();

              return RefreshIndicator(
                onRefresh: cubit.load,
                child: BlocBuilder<OwnerPropertyCubit, OwnerPropertyState>(
                  builder: (context, state) {
                    final resource = state.resource;

                    Widget header = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageHeader(
                          widthScale: widthScale,
                          leftGap: 30 * widthScale,
                          left: AppSvgIconButton(
                            widthScale: widthScale,
                            icon: AppIcons.backArrowProp,
                            iconWidth: 16,
                            iconHeight: 16,
                            onTap: () {
                              context.pop();
                            },
                          ),
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
                              context.push(RouteNames.listPropertyTypeScreen);                            },
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

                    if (resource.isInitialFailure) {
                      return ListView(
                        padding: EdgeInsets.symmetric(horizontal: 23 * widthScale),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          header,
                          ErrorRetryView(
                            message: resource.errorMessage ?? AppStrings.somethingWentWrong,
                            onRetry: cubit.load,
                          ),
                        ],
                      );
                    }

                    if (resource.isInitialLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final properties = state.properties;

                    return NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
                          cubit.loadMore();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 23 * widthScale),
                        itemCount: 1 + (properties.isEmpty ? 1 : properties.length) + (state.isLoadingMore ? 1 : 0) + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) return header;

                          final bodyIndex = index - 1;

                          if (properties.isEmpty) {
                            if (bodyIndex == 0) {
                              return EmptyStateView(
                                widthScale: widthScale,
                                icon: AppIcons.noProperty,
                                title: AppStrings.noPropertiesFound,
                              );
                            }
                            return SizedBox(height: 40 * heightScale);
                          }

                          if (bodyIndex < properties.length) {
                            final property = properties[bodyIndex];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16 * heightScale),
                              child: PropertyCard(
                                property: property,
                                widthScale: widthScale,
                                showStatus: true,
                                propMang: true,
                                onViewDetails: () {
                                  // TODO: navigate to details screen once it exists.
                                },
                                onEdit: () async {
                                  final changed = await context.push<bool>(
                                    RouteNames.ownerEditPropertyScreen,
                                    extra: property,
                                  );
                                  if (changed == true) cubit.load();
                                },
                                onDelete: () async {
                                  final changed = await context.push<bool>(
                                    RouteNames.ownerDeletePropertyScreen,
                                    extra: property,
                                  );
                                  if (changed == true) cubit.load();
                                },
                              ),
                            );
                          }

                          if (bodyIndex == properties.length && state.isLoadingMore) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16 * heightScale),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }

                          return SizedBox(height: 40 * heightScale);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}