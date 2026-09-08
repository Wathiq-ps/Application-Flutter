  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:go_router/go_router.dart';
  import 'package:mobile/config/routes/routes_names.dart';
  import 'package:mobile/core/di/injector.dart';
  import 'package:mobile/features/auth/domain/entities/auth_mode.dart';
  import 'package:mobile/features/auth/presentation/state_mangement/cubit/auth_cubit.dart';
  import 'package:mobile/features/property/presentation/pages/add_property_page_four.dart';
  import 'package:mobile/features/property/presentation/pages/proof_of_ownership_page.dart';
  import 'package:mobile/features/property/presentation/pages/review_listing_page.dart';
  import 'package:mobile/features/verification/presentation/verification_pending_screen.dart';
  import 'package:mobile/features/verification/presentation/verify_identity_screen.dart';
  import 'package:mobile/features/verification/presentation/verify_selfie_identity_screen.dart';
  import 'package:mobile/features/property/presentation/pages/add_property_page_two.dart';
  import '../../features/auth/presentation/pages/email_login_screen.dart';
  import '../../features/auth/presentation/pages/email_registe_screen.dart';
  import '../../features/auth/presentation/pages/phone_login_screen.dart';
  import '../../features/auth/presentation/pages/phone_register_screen.dart';
  import '../../features/main_navigation/presentation/pages/main_navigation_screen.dart';
import '../../features/main_navigation/presentation/state_mangment/navigation_cubit.dart';
import '../../features/onboarding/presentation/onboardin_screen.dart';
  import '../../features/onboarding/presentation/onboarding_login_screen.dart';
  import '../../features/onboarding/presentation/splash_screen.dart';
  import '../../features/property/presentation/pages/add_property_page_one.dart';
  import '../../features/property/presentation/pages/add_property_page_three.dart';

  class AppRoutes {
    AppRoutes._();

    // ─────────────────────────────────────────────
    // Router
    // ─────────────────────────────────────────────

    static final GoRouter router = GoRouter(
      initialLocation: RouteNames.mainNavigation,

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
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
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
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
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
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
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
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
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
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
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
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),

        // ─────────────────────────────────────────────
        // Property
        // ─────────────────────────────────────────────
        GoRoute(
          path: RouteNames.addPropertyScreenOne,
          name: 'addPropertScreenOne',
          builder: (context, state) {
            return const AddPropertyScreenOne();
          },
        ),

        GoRoute(
          path: RouteNames.addPropertyScreenTwo,
          name: 'addPropertScreenTwo',
          builder: (context, state) {
            return const AddPropertyScreenTwo();
          },
        ),

        GoRoute(
          path: RouteNames.addPropertyScreenThree,
          name: 'addPropertScreenThree',
          builder: (context, state) {
            return const AddPropertyScreenThree();
          },
        ),

        GoRoute(
          path: RouteNames.addPropertyScreenFour,
          name: 'addPropertScreenFour',
          builder: (context, state) {
            return const AddPropertyScreenFour();
          },
        ),

        GoRoute(
          path: RouteNames.proofOfOwnershipPage,
          name: 'proofOfOwnershipPage',
          builder: (context, state) {
            return const ProofOfOwnershipPage();
          },
        ),

        GoRoute(
          path: RouteNames.reviewListingPage,
          name: 'reviewListingPage',
          builder: (context, state) {
            return const ReviewListingPage();
          },
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

        GoRoute(
          path: RouteNames.mainNavigation,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => NavigationCubit(),
              child: const MainNavigationScreen(),
            );
          },
        ),
      ],
    );
  }