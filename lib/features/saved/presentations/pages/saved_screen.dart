import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/constant/strings.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import 'package:mobile/core/widget/app_icon_label_trigger.dart';
import 'package:mobile/core/widget/empty_state_view.dart';
import 'package:mobile/core/widget/page_header.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widget/property_card.dart';
import '../state_management/saved_cubit.dart';
import '../state_management/saved_state.dart';
import '../utils/property_display_mapper.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    final double widthScale = context.screenWidth / figmaWidth;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17 * widthScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15 * widthScale),

            PageHeader(
              widthScale: widthScale,
              center: Text(
                AppStrings.myFavorites,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF00081E),
                  fontSize: 18 * widthScale,
                  fontWeight: FontWeight.w500,
                  height: 24 / 18,
                  letterSpacing: -0.45,
                ),
              ),
            ),

            SizedBox(height: 20 * widthScale),

            Expanded(
              child: BlocBuilder<SavedCubit, SavedState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final favorites = state.favorites;

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      if (favorites.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12 * widthScale),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  favorites.length == 1
                                      ? AppStrings.onePropertySaved
                                      : AppStrings.propertiesSavedCount(favorites.length),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11 * widthScale,
                                    fontWeight: FontWeight.w500,
                                    height: 14 / 11,
                                    letterSpacing: 0.44,
                                  ),
                                ),
                                AppLabelIconTrigger(
                                  widthScale: widthScale,
                                  label: AppStrings.recentlySaved,
                                  icon: AppIcons.arrowDown,
                                  // TODO: no sort options specified yet.
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (favorites.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: EmptyStateView(
                              widthScale: widthScale,
                              icon: Icons.favorite_border_rounded,
                              title: AppStrings.noSavedPropertiesTitle,
                              subtitle: AppStrings.noSavedPropertiesSubtitle,
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildListDelegate([
                            for (final property in favorites)
                              PropertyCard(
                                property: toDisplayItem(property),
                                widthScale: widthScale,
                                showStatus: false,
                                showFavorite: true,
                                isFavorite: true,
                                onFavoritePressed: () => Injector.favoritesRepository.removeFavorite(property.id),
                                onViewDetails: () { /* TODO: navigate */ },
                              ),
                          ]),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}