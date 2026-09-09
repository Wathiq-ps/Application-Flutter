import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({
    super.key,
    this.onGetStarted,
  });

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale =
        MediaQuery.sizeOf(context).width / figmaWidth;

    final double bannerHeight = 184 * widthScale;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        16 * widthScale,
      ),
      child: Container(
        width: double.infinity,
        height: bannerHeight,
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
            // ─────────────────────────────────────
            // Banner Image
            // ─────────────────────────────────────

            Image.asset(
              'assets/images/home/home_banner.jpg',
              fit: BoxFit.cover,
            ),

            // ─────────────────────────────────────
            // Navy Gradient
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
            // Content
            // ─────────────────────────────────────

            Padding(
              padding: EdgeInsets.fromLTRB(
                20 * widthScale,
                20 * widthScale,
                20 * widthScale,
                6 * widthScale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   AppStrings.findYourPerfectProperty,
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
                      AppStrings.buySellOrRent,
                      style: TextStyle(
                        color: const Color(0xCCE7E8E9),
                        fontSize: 12 * widthScale,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onGetStarted,
                        child: Container(
                          width: 116 * widthScale,
                          height: 24 * widthScale,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                            BorderRadius.circular(9999),
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
                          child: Text(
                            AppStrings.getStartedHome,
                            style: TextStyle(
                              color: const Color(0xFF0A1F44),
                              fontSize: 13 * widthScale,
                              fontWeight: FontWeight.w600,
                              height: 24 / 13,
                            ),
                          ),
                        ),
                      ),

                      // Indicators
                      Row(
                        children: [
                          _Indicator(
                            width: 16 * widthScale,
                          ),
                          SizedBox(
                            width: 6 * widthScale,
                          ),
                          _Indicator(
                            width: 6 * widthScale,
                            opacity: 0.4,
                          ),
                          SizedBox(
                            width: 6 * widthScale,
                          ),
                          _Indicator(
                            width: 6 * widthScale,
                            opacity: 0.4,
                          ),
                        ],
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

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.width,
    this.opacity = 1,
  });

  final double width;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6 *
          (MediaQuery.sizeOf(context).width / 393),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(
          alpha: opacity,
        ),
        borderRadius: BorderRadius.circular(9999),
      ),
    );
  }
}