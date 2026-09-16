  import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/core/constant/app_icons.dart';
  import 'package:mobile/core/extensions/media_query_extensions.dart';
  import 'package:mobile/core/widget/property_filter_chips.dart';

  import '../../../../core/widget/app_profile_avatar.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/page_header.dart';
  import '../../../../core/widget/page_search_bar.dart';
  import '../widgets/all_properties_section.dart';
  import '../widgets/home_greeting.dart';
import '../widgets/home_promo_banner.dart';

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

      return SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23 * widthScale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15 * heightScale),

                    PageHeader(
                      widthScale: widthScale,
                      mainAxisAlignment: MainAxisAlignment.start,
                      leftGap: 10,
                      rightGap: 8,
                      left: AppProfileAvatar(
                        widthScale: widthScale,
                        size: 36,
                        initialsSource: 'samer',
                        showInitialsFallback: false,
                        onTap: () {
                          // TODO: open profile
                        },
                      ),
                      center: HomeGreeting(
                        widthScale: widthScale,
                        userName: 'Samer',
                      ),
                      right: AppSvgIconButton(
                        widthScale: widthScale,
                        icon: AppIcons.notifications,
                        boxSize: 24,
                        iconWidth: 16,
                        iconHeight: 20,
                        onTap: () {
                          // TODO: open notifications
                        },
                      ),

                    ),
                    SizedBox(height: 25 * heightScale),

                    PageSearchBar(widthScale: widthScale),

                    SizedBox(height: 13 * heightScale),

                    PropertyFilterChips(widthScale: widthScale),

                    SizedBox(height: 13 * heightScale),

                    HomePromoBanner(onGetStarted: (){},),

                    SizedBox(height: 13 * heightScale),

                    const AllPropertiesSection(),

                    SizedBox(height: 90 * heightScale),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }