import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/features/home/presentation/state_mangement/home_state.dart'
    show PropertyFilter;
import 'package:mobile/features/main_navigation/presentation/state_mangment/navigation_cubit.dart';
import 'package:mobile/features/main_navigation/presentation/state_mangment/navigation_state.dart';
import 'package:mobile/features/main_navigation/presentation/state_mangment/navigation_tab.dart';
import 'package:mobile/features/saved/presentations/utils/property_display_mapper.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/cached_data_banner.dart';
import '../../../../core/widget/empty_state_view.dart';
import '../../../../core/widget/error_retry_view.dart';
import '../../../../core/widget/page_header.dart';
import '../../../../core/widget/page_search_bar.dart';
import '../../../../core/widget/property_card.dart';
import '../../../../core/widget/property_filter_chips.dart';
import '../state_management/search_cubit.dart';
import '../state_management/search_state.dart';
import '../widgets/applied_query_chip.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(
        Injector.searchRepository,
        Injector.favoritesRepository,
      )..search(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _lastFocusRequestId = 0;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onNavigationChanged(NavigationState nav) {
    if (nav.selectedIndex != AppTab.search.index) {
      _focusNode.unfocus();
      return;
    }
    if (nav.searchFocusRequestId != _lastFocusRequestId) {
      _lastFocusRequestId = nav.searchFocusRequestId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  void _clearAll(SearchCubit cubit) {
    _controller.clear();
    cubit.clearQuery();
  }

  void _showUnavailable() {
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
    const double figmaHeight = 852.0;
    final double ws = context.screenWidth / figmaWidth;
    final double hs = context.screenHeight / figmaHeight;
    final cubit = context.read<SearchCubit>();

    return BlocListener<NavigationCubit, NavigationState>(
      listenWhen: (p, c) =>
      p.selectedIndex != c.selectedIndex ||
          p.searchFocusRequestId != c.searchFocusRequestId,
      listener: (context, nav) => _onNavigationChanged(nav),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20 * ws),
          child: Column(
            children: [
              SizedBox(height: 15 * hs),

              PageHeader(
                widthScale: ws,
                expandCenter: true,
                left: AppSvgIconButton(
                  widthScale: ws,
                  icon: AppIcons.backArrowProp,
                  iconWidth: 20,
                  iconHeight: 16,
                  onTap: () {
                    _focusNode.unfocus();
                    context.read<NavigationCubit>().changeTab(0); // Home
                  },
                ),
                center: Text(
                  AppStrings.searchProperties,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18 * ws,
                    fontWeight: FontWeight.w500,
                    height: 24 / 18,
                    letterSpacing: -0.45,
                  ),
                ),
                right: GestureDetector(
                  onTap: _showUnavailable, // TODO: filters sheet
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(AppIcons.filter,height: 18 * ws,width: 18 * ws,),
                ),
              ),

              SizedBox(height: 16 * hs),

              PageSearchBar(
                widthScale: ws,
                controller: _controller,
                focusNode: _focusNode,
                onChanged: cubit.onQueryChanged,
                onSubmitted: (_) => cubit.submit(),
                onClear: () => _clearAll(cubit),
              ),

              BlocSelector<SearchCubit, SearchState, String>(
                selector: (s) => s.appliedQuery,
                builder: (context, applied) {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.topLeft,
                    child: applied.isEmpty
                        ? const SizedBox(width: double.infinity)
                        : Padding(
                      padding: EdgeInsets.only(top: 12 * hs),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppliedQueryChip(
                          label: applied,
                          widthScale: ws,
                          onRemove: () => _clearAll(cubit),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 14 * hs),

              Align(
                alignment: Alignment.centerLeft,
                child: BlocSelector<SearchCubit, SearchState, PropertyFilter>(
                  selector: (s) => s.filter,
                  builder: (context, filter) => PropertyFilterChips(
                    widthScale: ws,
                    selectedIndex: filter.chipIndex,
                    onChanged: (index) =>
                        cubit.changeFilter(PropertyFilter.fromChipIndex(index)),
                  ),
                ),
              ),

              SizedBox(height: 12 * hs),

              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) =>
                      _buildResults(context, state, cubit, ws, hs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(
      BuildContext context,
      SearchState state,
      SearchCubit cubit,
      double ws,
      double hs,
      ) {
    final resource = state.resource;

    // Failed AND nothing cached -> retry view
    if (resource.isInitialFailure) {
      return Center(
        child: ErrorRetryView(
          message: resource.errorMessage ?? AppStrings.somethingWentWrong,
          onRetry: cubit.search,
        ),
      );
    }

    if (resource.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = state.items;

    return RefreshIndicator(
      onRefresh: () => cubit.search(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 300) {
            cubit.loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Saved data shown because the refresh failed
                  if (resource.isShowingStaleData)
                    CachedDataBanner(
                      widthScale: ws,
                      updatedAt: resource.updatedAt,
                      onRetry: () => cubit.search(refresh: true),
                    ),
                  if (items.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12 * ws),
                      child: Text(
                        state.total == 1
                            ? AppStrings.onePropertyFound
                            : AppStrings.propertiesFoundCount(state.total),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11 * ws,
                          fontWeight: FontWeight.w500,
                          height: 14 / 11,
                          letterSpacing: 0.44,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: EmptyStateView(
                    widthScale: ws,
                    title: AppStrings.noPropertiesFound,
                    subtitle: AppStrings.noSearchResultsSubtitle,
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final property = items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16 * ws),
                      child: PropertyCard(
                        property: toDisplayItem(property),
                        widthScale: ws,
                        showStatus: false,
                        showFavorite: true,
                        isFavorite: state.favoriteIds.contains(property.id),
                        onFavoritePressed: () => cubit.toggleFavorite(property),
                        onViewDetails: () {
                          // TODO: navigate to property details
                        },
                      ),
                    );
                  },
                  childCount: items.length,
                ),
              ),

            SliverToBoxAdapter(
              child: state.isLoadingMore
                  ? Padding(
                padding: EdgeInsets.symmetric(vertical: 16 * hs),
                child: const Center(child: CircularProgressIndicator()),
              )
                  : SizedBox(height: 24 * hs),
            ),
          ],
        ),
      ),
    );
  }
}