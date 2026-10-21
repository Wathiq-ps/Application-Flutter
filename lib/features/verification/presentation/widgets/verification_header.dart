import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_svg_button.dart';

/// Back button + "Verify Your Identity" + "Step x of 2".
class VerificationHeader extends StatelessWidget {
  const VerificationHeader({
    super.key,
    required this.title,
    required this.step,
    this.onBack,
  });

  final String title;
  final String step;
  final VoidCallback? onBack;

  void _defaultBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.mainNavigation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final widthScale = context.widthScale;
    final heightScale = context.heightScale;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        21 * widthScale,
        14 * heightScale,
        21 * widthScale,
        24 * heightScale,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppSvgIconButton(
              widthScale: widthScale,
              icon: AppIcons.back,
              boxSize: 24,
              iconWidth: 20,
              iconHeight: 20,
              flipForRtl: true,
              onTap: onBack ?? () => _defaultBack(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32 * widthScale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: 25 * widthScale,
                    height: 32 / 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5 * widthScale),
                Text(
                  step,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.white70,
                    fontSize: 14 * widthScale,
                    height: 16 / 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}