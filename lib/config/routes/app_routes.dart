import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/routes/routes_names.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/features/auth/domain/entities/auth_mode.dart';
import 'package:mobile/features/auth/presentation/state_mangement/cubit/auth_cubit.dart';
import 'package:mobile/features/property/presentation/pages/list_property_photos_screen.dart';
import 'package:mobile/features/property/presentation/pages/proof_of_ownership_page.dart';
import 'package:mobile/features/property/presentation/pages/review_listing_page.dart';
import 'package:mobile/features/verification/presentation/verification_pending_screen.dart';
import 'package:mobile/features/verification/presentation/verify_identity_screen.dart';
import 'package:mobile/features/verification/presentation/verify_selfie_identity_screen.dart';
import 'package:mobile/features/property/presentation/pages/property_location_screen.dart';
import '../../features/auth/presentation/pages/email_login_screen.dart';
import '../../features/auth/presentation/pages/email_registe_screen.dart';
import '../../features/auth/presentation/pages/phone_login_screen.dart';
import '../../features/auth/presentation/pages/phone_register_screen.dart';
import '../../features/onboarding/presentation/onboardin_screen.dart';
import '../../features/onboarding/presentation/onboarding_login_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/property/presentation/pages/list_property_type_screen.dart';
import '../../features/property/presentation/pages/list_property_features_screen.dart';
import '../../features/property/presentation/state_management/create_property_cubit.dart';

class AppRoutes {
  AppRoutes._();

  // ─────────────────────────────────────────────
  // Router
  // ─────────────────────────────────────────────

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.listPropertyTypeScreen,

    routes: [
      // ─────────────────────────────────────────────
      // Splash
      // ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      // ─────────────────────────────────────────────
      // Onboarding
      // ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.onboardingScreen,
        name: 'onboardingScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const OnBoardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.onboardingLoginScreen,
        name: 'onboardingLoginScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const OnBoardingLoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),

      // ─────────────────────────────────────────────
      // Login
      // ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.phoneLoginScreen,
        name: 'phoneLoginScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const PhoneLoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),
      // ─────────────────────────────────────────────
      // Email Login
      // ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.emailLoginScreen,
        name: 'emailLoginScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => AuthCubit(
                mode: AuthMode.login,
                authRepository: Injector.authRepository,
              ),
              child: const EmailLoginScreen(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),

      // ─────────────────────────────────────────────
      // Register
      // ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.phoneRegisterScreen,
        name: 'phoneRegisterScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const PhoneRegisterScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),

      GoRoute(
        path: RouteNames.emailRegisterScreen,
        name: 'emailRegisterScreen',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => AuthCubit(
                mode: AuthMode.register,
                authRepository: Injector.authRepository,
              ),
              child: const EmailRegisterScreen(),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          );
        },
      ),

      // ─────────────────────────────────────────────
      // Property
      // ─────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<CreatePropertyCubit>(
            create: (_) => CreatePropertyCubit(
              createPropertyUseCase: Injector.createPropertyUseCase,
            ),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.listPropertyTypeScreen,
            name: 'listPropertyTypeScreen',
            builder: (context, state) {
              final isEdit = state.extra is bool
                  ? state.extra as bool
                  : (state.extra as Map<String, dynamic>?)?['isEdit'] as bool? ??
                      false;
              return ListPropertyTypeScreen(isEdit: isEdit);
            },
          ),
          GoRoute(
            path: RouteNames.propertyLocationScreen,
            name: 'propertyLocationScreen',
            builder: (context, state) {
              final isEdit = state.extra is bool
                  ? state.extra as bool
                  : (state.extra as Map<String, dynamic>?)?['isEdit'] as bool? ??
                      false;
              return PropertyLocationScreen(isEdit: isEdit);
            },
          ),
          GoRoute(
            path: RouteNames.listPropertyFeaturesScreen,
            name: 'listPropertyFeaturesScreen',
            builder: (context, state) {
              final isEdit = state.extra is bool
                  ? state.extra as bool
                  : (state.extra as Map<String, dynamic>?)?['isEdit'] as bool? ??
                      false;
              return ListPropertyFeaturesScreen(isEdit: isEdit);
            },
          ),
          GoRoute(
            path: RouteNames.listPropertyPhotosScreen,
            name: 'listPropertyPhotosScreen',
            builder: (context, state) {
              final isEdit = state.extra is bool
                  ? state.extra as bool
                  : (state.extra as Map<String, dynamic>?)?['isEdit'] as bool? ??
                      false;
              return ListPropertyPhotosScreen(isEdit: isEdit);
            },
          ),
          GoRoute(
            path: RouteNames.proofOfOwnershipPage,
            name: 'proofOfOwnershipPage',
            builder: (context, state) {
              final isEdit = state.extra is bool
                  ? state.extra as bool
                  : (state.extra as Map<String, dynamic>?)?['isEdit'] as bool? ??
                      false;
              return ProofOfOwnershipPage(isEdit: isEdit);
            },
          ),
          GoRoute(
            path: RouteNames.reviewListingPage,
            name: 'reviewListingPage',
            builder: (context, state) {
              return const ReviewListingPage();
            },
          ),
        ],
      ),

      // ─────────────────────────────────────────────
      // Verification
      // ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.verifyIdentityScreen,
        name: 'verifyIdentityScreen',
        builder: (context, state) {
          return const VerifyIdentityScreen();
        },
      ),

      GoRoute(
        path: RouteNames.verifySelfieIdentityScreen,
        name: 'verifySelfieIdentityScreen',
        builder: (context, state) {
          return const VerifySelfieIdentityScreen();
        },
      ),

      GoRoute(
        path: RouteNames.verificationPendingScreen,
        name: 'verificationPendingScreen',
        builder: (context, state) {
          return const VerificationPendingScreen();
        },
      ),
    ],
  );
}
