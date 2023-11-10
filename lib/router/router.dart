import 'package:flutter/material.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/auth/otp_verification.dart';
import 'package:meeting_scheduler/screens/auth/otp_verified.dart';
import 'package:meeting_scheduler/screens/auth/sign_up.dart';
import 'package:meeting_scheduler/screens/home/home_screen_wrapper.dart';
import 'package:meeting_scheduler/screens/onboarding/onboarding_screen_wrapper.dart';

class AppNavigator {
  const AppNavigator._();

  //! NAVIGATE TO A PAGE WITHOUT REPLACING THE PREVIOUS PAGE.
  static Future<void> navigateToPage({
    required String thePageRouteName,
    required BuildContext context,
  }) =>
      Navigator.of(context).pushNamed(thePageRouteName);

  //! NAVIGATE TO A PAGE AND REPLACE THE PREVIOUS PAGE
  static Future<void> navigateToReplacementPage({
    required String thePageRouteName,
    required BuildContext context,
  }) =>
      Navigator.of(context).pushReplacementNamed(thePageRouteName);

  static Future<void> pushNamedAndRemoveUntil({
    required String thePageRouteName,
    required BuildContext context,
  }) =>
      Navigator.of(context)
          .pushNamedAndRemoveUntil(thePageRouteName, (route) => false);

  //! ROUTE GENERATOR
  static Route<dynamic> generateRoute({required RouteSettings routeSettings}) {
    switch (routeSettings.name) {
      //! ONBOARDING SCREEN
      case AppRoutes.onboardingScreen:
        return GetPageRoute._getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const OnboardingScreenWrapper(),
        );

      //! AUTH
      case AppRoutes.signUp:
        return GetPageRoute._getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const SignUpScreen(),
        );

      case AppRoutes.otpVerification:
        return GetPageRoute._getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const OTPVerification(),
        );

      case AppRoutes.otpVerified:
        return GetPageRoute._getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const OTPVerified(),
        );

      //! HOME SCREEN WRAPPER - CARRYING BOTTOM NAV BAR & HOME SCREEN PAGES
      case AppRoutes.homeScreen:
        return GetPageRoute._getPageRoute(
            routeName: routeSettings.name,
            args: routeSettings.arguments,
            view: const HomeScreenWrapper());

      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreenWrapper(),
        );
    }
  }
}

class GetPageRoute {
  //! GET A PAGE ROUTE
  static PageRoute _getPageRoute(
          {String? routeName, Widget? view, Object? args}) =>
      MaterialPageRoute(
        settings: RouteSettings(name: routeName, arguments: args),
        builder: (_) => view!,
      );
}
