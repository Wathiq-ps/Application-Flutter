import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/constant/strings.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import 'package:mobile/core/widget/app_profile_avatar.dart';
import 'package:mobile/core/widget/page_header.dart';
import '../../../../config/routes/routes_names.dart';
import '../state_management/profile_cubit.dart';
import '../state_management/profile_state.dart';
import '../widgets/language_picker_sheet.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/verified_status_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(Injector.profileRepository)..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

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
    final profileCubit = context.read<ProfileCubit>();

    return SizedBox.expand(
      child: Stack(
        children: [
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
              padding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
              child: PageHeader(
                widthScale: widthScale,
                center: Text(
                  AppStrings.profile,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                  // Name + verification badge (from GET /api/v1/profile)
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state.isInitialFailure) {
                        return Column(
                          children: [
                            Text(
                              state.errorMessage ?? AppStrings.somethingWentWrong,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: profileCubit.load,
                              child: const Text(AppStrings.retry),
                            ),
                          ],
                        );
                      }

                      if (state.isInitialLoading) {
                        return SizedBox(
                          height: 64 * heightScale,
                          child: const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      final profile = state.data!;
                      final String displayName =
                      profile.name.trim().isNotEmpty ? profile.name : profile.email;

                      return Column(
                        children: [
                          Text(
                            displayName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 24 * widthScale,
                            ),
                          ),
                          SizedBox(height: 8 * heightScale),
                          VerifiedStatusBadge(
                            isVerified: profile.isVerified,
                            widthScale: widthScale,
                          ),
                        ],
                      );
                    },
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
                    onTap: () async {
                      await context.push(RouteNames.verifyIdentityScreen);
                      profileCubit.load(); // refresh badge when coming back
                    },
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.properties,
                    title: AppStrings.myProperties,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 20 * widthScale,
                    iconHeight: 18 * widthScale,
                    onTap: () => context.push(RouteNames.ownerPropertiesScreen),
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
                    onTap: () async {
                      await context.push(RouteNames.editProfileScreen);
                      profileCubit.load();
                    },
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.language,
                    title: AppStrings.language,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    onTap: () => showLanguagePicker(context: context, widthScale: widthScale),
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