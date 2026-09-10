import 'package:flutter/material.dart';
import 'package:mobile/core/constant/images_path.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import 'promo_indicator.dart';

class PromoBannerData {
  const PromoBannerData({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String title;
  final String subtitle;
}

class HomePromoBanner extends StatefulWidget {
  const HomePromoBanner({
    super.key,
    this.onGetStarted,
  });

  final VoidCallback? onGetStarted;

  @override
  State<HomePromoBanner> createState() => HomePromoBannerState();
}

class HomePromoBannerState extends State<HomePromoBanner> {
  final PageController pageController = PageController();

  // Temporary 3 banners.
  //
  // You can replace the images later with:
  // ImagePath.banner1
  // ImagePath.banner2
  // ImagePath.banner3
  //
  // The PageView and indicators will automatically adapt
  // to the number of banners in this list.
  final List<PromoBannerData> banners = const [
    PromoBannerData(
      image: ImagePath.villa,
      title: AppStrings.findYourPerfectProperty,
      subtitle: AppStrings.buySellOrRent,
    ),
    PromoBannerData(
      image: ImagePath.villa,
      title: AppStrings.findYourPerfectProperty,
      subtitle: AppStrings.buySellOrRent,
    ),
    PromoBannerData(
      image: ImagePath.villa,
      title: AppStrings.findYourPerfectProperty,
      subtitle: AppStrings.buySellOrRent,
    ),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale = context.screenWidth / figmaWidth;
    final double bannerHeight = 184 * widthScale;

    return SizedBox(
      height: bannerHeight,
      child: PageView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return PromoBannerCard(
            data: banners[index],
            widthScale: widthScale,
            onGetStarted: widget.onGetStarted,
            pageController: pageController,
            pageCount: banners.length,
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Single banner card
// ─────────────────────────────────────────────

class PromoBannerCard extends StatelessWidget {
  const PromoBannerCard({
    super.key,
    required this.data,
    required this.widthScale,
    required this.pageController,
    required this.pageCount,
    this.onGetStarted,
  });

  final PromoBannerData data;
  final double widthScale;
  final PageController pageController;
  final int pageCount;
  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        16 * widthScale,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.10),
              offset: Offset(
                0,
                4 * widthScale,
              ),
              blurRadius: 6 * widthScale,
              spreadRadius: 3 * widthScale,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              data.image,
              fit: BoxFit.cover,
            ),

            // ─────────────────────────────────────
            // Dark gradient overlay
            // ─────────────────────────────────────

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xF20A1F44),
                    const Color(0xCC0A1F44),
                    const Color(0x000A1F44),
                  ],
                  stops: const [
                    0.0,
                    0.5,
                    1.0,
                  ],
                ),
              ),
            ),

            // ─────────────────────────────────────
            // Banner content
            // ─────────────────────────────────────

            Padding(
              padding: EdgeInsets.fromLTRB(
                20 * widthScale,
                20 * widthScale,
                20 * widthScale,
                20 * widthScale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20 * widthScale,
                      fontWeight: FontWeight.w600,
                      height: 25 / 20,
                    ),
                  ),

                  SizedBox(
                    height: 7 * widthScale,
                  ),

                  SizedBox(
                    width: 195 * widthScale,
                    child: Text(
                      data.subtitle,
                      style: TextStyle(
                        color: AppColors.promoBannerTextColor,
                        fontSize: 12 * widthScale,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ─────────────────────────────────────
                  // Bottom row
                  // ─────────────────────────────────────

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ─────────────────────────────────────
                      // Get Started button
                      // ─────────────────────────────────────

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(
                                alpha: 0.10,
                              ),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: AppElevatedButton(
                          text: AppStrings.getStartedHome,
                          onPressed: onGetStarted ?? () {},
                          width: 116 * widthScale,
                          height: 24 * widthScale,
                          backgroundColor: AppColors.white,
                          borderRadius: 9999,
                          elevation: 0,
                          textStyle: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13 * widthScale,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // ─────────────────────────────────────
                      // Page indicators
                      // ─────────────────────────────────────

                      AnimatedBuilder(
                        animation: pageController,
                        builder: (context, _) {
                          double currentPageValue = 0;

                          if (pageController.hasClients &&
                              pageController.page != null) {
                            currentPageValue = pageController.page!;
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              pageCount,
                                  (index) {
                                final double distance =
                                (currentPageValue - index)
                                    .abs()
                                    .clamp(0.0, 1.0);

                                // Selected indicator = 16
                                // Unselected indicator = 6
                                final double dotWidth =
                                    (16 - (10 * distance)) * widthScale;

                                // Selected indicator = full opacity
                                // Unselected indicator = 40% opacity
                                final double dotOpacity =
                                    1 - (0.6 * distance);

                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0
                                        ? 0
                                        : 6 * widthScale,
                                  ),
                                  child: PromoIndicator(
                                    width: dotWidth,
                                    widthScale: widthScale,
                                    opacity: dotOpacity,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}