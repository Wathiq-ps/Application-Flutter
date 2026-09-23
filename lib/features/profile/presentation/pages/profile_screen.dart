import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/constant/strings.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import 'package:mobile/core/widget/app_circular_icon_button.dart';
import 'package:mobile/core/widget/app_profile_avatar.dart';
import 'package:mobile/core/widget/page_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/verified_status_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double figmaWidth = 393.0;
  static const double figmaHeight = 852.0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = context.screenWidth;
    final double screenHeight = context.screenHeight;
    final double widthScale = screenWidth / figmaWidth;
    final double heightScale = screenHeight / figmaHeight;

    final double avatarSize = 112 * widthScale;
    final double sheetTopOffset = 198 * heightScale;
    final double avatarTopOffset = sheetTopOffset - (avatarSize / 2);

    return SizedBox.expand(
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              ImagePath.background,
              fit: BoxFit.fill,
            ),
          ),

          // Background Overlay
          Positioned.fill(
            child: Container(
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
          ),

          // Page Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20 * widthScale,
              ),
              child: PageHeader(
                widthScale: widthScale,
                left: AppCircularIconButton(
                  icon: AppIcons.back,
                  onPressed: () {
                    // TODO: handle back
                  },
                  size: 36 * widthScale,
                  iconWidth: 18 * widthScale,
                  iconHeight: 18 * widthScale,
                ),
                center: Text(
                  AppStrings.profile,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                right: SizedBox(
                  width: 36 * widthScale,
                  height: 36 * widthScale,
                ),
                showRight: true,
                expandCenter: true,
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: sheetTopOffset,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32 * widthScale),
                  topRight: Radius.circular(32 * widthScale),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.only(
                  top: (avatarSize / 2) + (16 * heightScale),
                  left: 20 * widthScale,
                  right: 20 * widthScale,
                  bottom: 24 * heightScale,
                ),
                children: [
                  Text(
                    "Samer Abu Zaina",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 24 * widthScale,
                    ),
                  ),

                  SizedBox(height: 8 * heightScale),

                  VerifiedStatusBadge(
                    isVerified: true,
                    widthScale: widthScale,
                  ),

                  SizedBox(height: 24 * heightScale),

                  ProfileMenuItem(
                    icon: AppIcons.identity,
                    title: AppStrings.identityVerification,
                    subtitle: AppStrings.status,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 18 * widthScale,
                    iconHeight: 19 * widthScale,
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.properties,
                    title: AppStrings.properties,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 20 * widthScale,
                    iconHeight: 18 * widthScale,
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.requests,
                    title: AppStrings.requests,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 24 * widthScale,
                    iconHeight: 24 * widthScale,
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.person,
                    title: AppStrings.editProfile,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 16 * widthScale,
                    iconHeight: 16 * widthScale,
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.language,
                    title: AppStrings.language,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    onTap: () {},
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.logout,
                    title: AppStrings.logout,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    isDestructive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: avatarTopOffset,
            left: 0,
            right: 0,
            child: Center(
              child: AppProfileAvatar(
                widthScale: widthScale,
                imageAsset: null,
                size: 112,
              ),
            ),
          ),
        ],
      ),
    );
  }
}