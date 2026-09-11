import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/page_header.dart';
import '../state_management/owner_property_cubit.dart';
import '../state_management/owner_property_state.dart';
import '../widgets/owner_property_card.dart';

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
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 23 * widthScale,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15 * heightScale),

                          Row(
                            children: [
                              Expanded(
                                child: PageHeader(
                                  widthScale: widthScale,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24 * heightScale),

                          // ─────────────────────────────────────
                          // Title row
                          // ─────────────────────────────────────
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.myProperties,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18 * widthScale,
                                  fontWeight: FontWeight.w500,
                                  height: 24 / 18,
                                  letterSpacing: -0.45,
                                ),
                              ),
                              AppElevatedButton(
                                text: AppStrings.addNewProperty,
                                onPressed: () {
                                  // TODO: navigate to add-property flow.
                                },
                                width: 97 * widthScale,
                                height: 32 * widthScale,
                                backgroundColor: AppColors.primary,
                                borderRadius: 9999,
                                elevation: 0,
                                preIcon: const Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                                iconSize: 10 * widthScale,
                                iconGap: 4 * widthScale,
                                textStyle: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12 * widthScale,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 24 * heightScale),

                          // ─────────────────────────────────────
                          // Count + status filter + visibility toggle
                          // ─────────────────────────────────────
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${state.properties.length} '
                                    '${AppStrings.propertiesListedCount}',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 11 * widthScale,
                                  fontWeight: FontWeight.w500,
                                  height: 14 / 11,
                                  letterSpacing: 0.44,
                                ),
                              ),

                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12 * widthScale,
                                      vertical: 6 * widthScale,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius:
                                      BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      AppStrings.allStatus,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 8 * widthScale,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.44,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 8 * widthScale),

                                  // Show/hide status badge toggle.
                                  GestureDetector(
                                    onTap: () => context
                                        .read<OwnerPropertyCubit>()
                                        .toggleStatusVisibility(),
                                    child: Icon(
                                      state.showStatusBadge
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18 * widthScale,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 16 * heightScale),
                        ],
                      ),
                    ),
                  ),

                  // ─────────────────────────────────────
                  // Property cards
                  // ─────────────────────────────────────
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 23 * widthScale,
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.properties.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: 16 * heightScale),
                      itemBuilder: (context, index) {
                        final property = state.properties[index];

                        return OwnerPropertyCard(
                          property: property,
                          widthScale: widthScale,
                          showStatus: state.showStatusBadge,
                          onViewDetails: () {
                            // TODO: navigate to details screen.
                          },
                          onEdit: () {
                            // TODO: context.push(RouteNames.ownerEditPropertyScreen, extra: property);
                          },
                          onDelete: () {
                            // TODO: context.push(RouteNames.ownerDeletePropertyScreen, extra: property);
                          },
                        );
                      },
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(height: 40 * heightScale),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}