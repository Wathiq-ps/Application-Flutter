import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/cached_data_banner.dart';
import '../../../../core/widget/error_retry_view.dart';
import '../../../../core/widget/page_header.dart';
import '../../../../core/widget/page_search_bar.dart';
import '../../../../core/widget/property_filter_chips.dart';
import '../../../main_navigation/presentation/state_mangment/navigation_cubit.dart';
import '../state_mangement/home_cubit.dart';
import '../state_mangement/home_state.dart';
import '../widgets/all_properties_section.dart';
import '../widgets/home_loading_view.dart';
import '../widgets/home_promo_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 852.0;
    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;

    final homeCubit = context.read<HomeCubit>();
    final navCubit = context.read<NavigationCubit>();

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: homeCubit.loadHome,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23 * widthScale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15 * heightScale),

                    PageHeader(widthScale: widthScale),

                    SizedBox(height: 25 * heightScale),

                    // Search bar -> Search tab + open the field
                    PageSearchBar(
                      widthScale: widthScale,
                      onTap: () => navCubit.goToSearch(focusSearchField: true),
                    ),

                    SizedBox(height: 13 * heightScale),

                    // For Sale / For Rent filter.
                    // Tapping the selected chip again clears it (= all).
                    BlocSelector<HomeCubit, HomeState, PropertyFilter>(
                      selector: (state) => state.filter,
                      builder: (context, filter) => PropertyFilterChips(
                        widthScale: widthScale,
                        selectedIndex: filter.chipIndex,
                        onChanged: (index) => homeCubit.changeFilter(
                          PropertyFilter.fromChipIndex(index),
                        ),
                      ),
                    ),

                    SizedBox(height: 13 * heightScale),

                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        final resource = state.resource;

                        // Failed AND nothing cached -> retry screen
                        if (resource.isInitialFailure) {
                          return ErrorRetryView(
                            message: resource.errorMessage ??
                                AppStrings.somethingWentWrong,
                            onRetry: homeCubit.loadHome,
                          );
                        }

                        // Nothing yet -> skeleton
                        if (resource.isInitialLoading) {
                          return HomeLoadingView(widthScale: widthScale);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Saved data shown because the refresh failed
                            if (resource.isShowingStaleData)
                              CachedDataBanner(
                                widthScale: widthScale,
                                updatedAt: resource.updatedAt,
                                onRetry: homeCubit.loadHome,
                              ),

                            if (state.featured.isNotEmpty) ...[
                              HomePromoBanner(
                                properties: state.featured,
                                widthScale: widthScale,
                                onPropertyTap: (property) {
                                  // TODO: navigate to property details
                                },
                              ),
                              SizedBox(height: 13 * heightScale),
                            ],

                            // View all -> Search tab
                            AllPropertiesSection(
                              properties: state.filteredProperties,
                              widthScale: widthScale,
                              onViewAll: () => navCubit.goToSearch(),
                              onPropertyTap: (property) {
                                // TODO: navigate to property details
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 90 * heightScale),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}