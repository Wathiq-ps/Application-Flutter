import 'package:flutter/material.dart';

import 'package:mobile/core/extensions/media_query_extensions.dart';
import '../widgets/all_properties_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_promo_banner.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/property_filter_chips.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 852.0;

    final double screenWidth = context.screenWidth;
    final double screenHeight = context.screenHeight;

    final double widthScale = screenWidth / figmaWidth;
    final double heightScale = screenHeight / figmaHeight;

    return (SafeArea(
        bottom: false,
        child: CustomScrollView(
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
                    SizedBox(
                      height: 15 * heightScale,
                    ),

                    // ─────────────────────────────────────
                    // Header
                    // ─────────────────────────────────────

                    const HomeHeader(),

                    SizedBox(
                      height: 34 * heightScale,
                    ),

                    // ─────────────────────────────────────
                    // Search
                    // ─────────────────────────────────────

                    const HomeSearchBar(),

                    SizedBox(
                      height: 13 * heightScale,
                    ),

                    // ─────────────────────────────────────
                    // Filters
                    // ─────────────────────────────────────

                    const PropertyFilterChips(),

                    SizedBox(
                      height: 13 * heightScale,
                    ),

                    // ─────────────────────────────────────
                    // Promo Banner
                    // ─────────────────────────────────────

                    const HomePromoBanner(),

                    SizedBox(
                      height: 13 * heightScale,
                    ),

                    // ─────────────────────────────────────
                    // Properties
                    // ─────────────────────────────────────

                    const AllPropertiesSection(),

                    SizedBox(
                      height: 90 * heightScale,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
  }
}