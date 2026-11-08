import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/constant/strings.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/error/auth_exception.dart';
import 'package:mobile/core/extensions/media_query_extensions.dart';
import 'package:mobile/core/widget/app_dialog.dart';
import 'package:mobile/core/widget/app_profile_avatar.dart';
import 'package:mobile/core/widget/app_top_snackbar.dart';
import 'package:mobile/core/widget/page_header.dart';
import '../../../../config/routes/routes_names.dart';
import '../state_management/profile_cubit.dart';
import '../state_management/profile_state.dart';
import '../../domain/entities/profile_entity.dart';
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

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppDialog.show<bool>(
      context,
      icon: AppIcons.errorDialog,
      iconWidth: 26,
      iconHeight: 22,
      title: AppStrings.logout,
      message: AppStrings.logoutConfirmationMessage,
      primaryText: AppStrings.confirm,
      primaryBackgroundColor: AppColors.error,
      onPrimary: () => Navigator.of(context).pop(true),
      secondaryText: AppStrings.cancelAction,
      onSecondary: () => Navigator.of(context).pop(false),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await Injector.authRepository.logout();
      if (context.mounted) context.go(RouteNames.onboardingScreen);
    } on AuthException catch (e) {
      if (!context.mounted) return;
      AppTopSnackBar.show(
        context,
        title: AppStrings.somethingWentWrong,
        message: e.message,
        prefixIcon: AppIcons.error,
      );
    } catch (_) {
      if (!context.mounted) return;
      AppTopSnackBar.show(
        context,
        title: AppStrings.somethingWentWrong,
        message: AppStrings.somethingWentWrong,
        prefixIcon: AppIcons.error,
      );
    }
  }

  String? _blockedActionMessage(
    ProfileEntity? profile, {
    required bool isIdentityAction,
  }) {
    if (profile == null) return AppStrings.somethingWentWrong;
    if (!profile.isProfileComplete) return AppStrings.completeProfileFirst;

    switch (profile.identityStatus) {
      case ProfileIdentityStatus.pending:
        return isIdentityAction ? null : AppStrings.uploadIdentityFirst;
      case ProfileIdentityStatus.underReview:
        return AppStrings.waitForIdentityReview;
      case ProfileIdentityStatus.approved:
        return isIdentityAction ? AppStrings.identityAlreadyVerified : null;
      case ProfileIdentityStatus.rejected:
        return isIdentityAction ? null : AppStrings.reuploadIdentity;
    }
  }

  void _showBlockedAction(BuildContext context, String message) {
    AppTopSnackBar.show(
      context,
      title: AppStrings.somethingWentWrong,
      message: message,
      prefixIcon: AppIcons.error,
    );
  }

  String _identityStatusLabel(ProfileIdentityStatus status) {
    switch (status) {
      case ProfileIdentityStatus.pending:
        return AppStrings.identityPending;
      case ProfileIdentityStatus.underReview:
        return AppStrings.identityUnderReview;
      case ProfileIdentityStatus.approved:
        return AppStrings.verifiedID;
      case ProfileIdentityStatus.rejected:
        return AppStrings.verificationRejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthScale = context.widthScale;
    final double heightScale = context.heightScale;
    final double avatarSize = 112 * widthScale;
    final double sheetTopOffset = 198 * heightScale;
    final double avatarTopOffset = sheetTopOffset - (avatarSize / 2);
    final profileCubit = context.read<ProfileCubit>();

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(ImagePath.background, fit: BoxFit.fill),
          ),

          // Background Overlay
          Positioned.fill(
            child: Container(color: AppColors.primary.withValues(alpha: 0.8)),
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
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state.isInitialFailure) {
                        return Column(
                          children: [
                            Text(
                              state.errorMessage ??
                                  AppStrings.somethingWentWrong,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: profileCubit.load,
                              child: Text(AppStrings.retry),
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
                      final String displayName = profile.name.trim().isNotEmpty
                          ? profile.name
                          : profile.email;

                      return Column(
                        children: [
                          Text(
                            displayName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24 * widthScale,
                                ),
                          ),
                          SizedBox(height: 8 * heightScale),
                          VerifiedStatusBadge(
                            status: profile.identityStatus,
                            isProfileComplete: profile.isProfileComplete,
                            widthScale: widthScale,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 24 * heightScale),

                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final profile = state.data;
                      return ProfileMenuItem(
                        icon: AppIcons.identity,
                        title: AppStrings.identityVerification,
                        subtitle: profile == null
                            ? AppStrings.status
                            : '${AppStrings.status} ${_identityStatusLabel(profile.identityStatus)}',
                        widthScale: widthScale,
                        heightScale: heightScale,
                        iconWidth: 18 * widthScale,
                        iconHeight: 19 * widthScale,
                        onTap: () async {
                          final blockedMessage = _blockedActionMessage(
                            profileCubit.state.data,
                            isIdentityAction: true,
                          );
                          if (blockedMessage != null) {
                            _showBlockedAction(context, blockedMessage);
                            return;
                          }
                          await context.push(RouteNames.verifyIdentityScreen);
                          profileCubit.load();
                        },
                      );
                    },
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.properties,
                    title: AppStrings.myProperties,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 20 * widthScale,
                    iconHeight: 18 * widthScale,
                    onTap: () {
                      final blockedMessage = _blockedActionMessage(
                        profileCubit.state.data,
                        isIdentityAction: false,
                      );
                      if (blockedMessage != null) {
                        _showBlockedAction(context, blockedMessage);
                        return;
                      }
                      context.push(RouteNames.ownerPropertiesScreen);
                    },
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.requests,
                    title: AppStrings.requests,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    iconWidth: 24 * widthScale,
                    iconHeight: 24 * widthScale,
                    onTap: () {
                      final blockedMessage = _blockedActionMessage(
                        profileCubit.state.data,
                        isIdentityAction: false,
                      );
                      if (blockedMessage != null) {
                        _showBlockedAction(context, blockedMessage);
                      }
                    },
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
                    onTap: () => showLanguagePicker(
                      context: context,
                      widthScale: widthScale,
                    ),
                  ),

                  ProfileMenuItem(
                    icon: AppIcons.logout,
                    title: AppStrings.logout,
                    widthScale: widthScale,
                    heightScale: heightScale,
                    isDestructive: true,
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: avatarTopOffset,
            left: 0,
            right: 0,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final profile = state.data;
                final name = profile?.name.trim() ?? '';
                final displayName = name.isNotEmpty
                    ? name
                    : profile?.email.trim();

                return Center(
                  child: AppProfileAvatar(
                    widthScale: widthScale,
                    imageUrl: profile?.profileImageUrl,
                    imageAsset: null,
                    initialsSource: displayName,
                    showInitialsFallback: true,
                    backgroundColor: AppColors.profileAvatarBackground,
                    initialsColor: AppColors.primary,
                    initialsFontSize: 48,
                    initialsFontWeight: FontWeight.w600,
                    initialsLineHeight: 0.5,
                    initialsLetterSpacing: 0,
                    borderColor: AppColors.white,
                    borderWidth: 4,
                    shadowBlurRadius: 2,
                    shadowOffset: const Offset(0, 1),
                    size: 112,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
