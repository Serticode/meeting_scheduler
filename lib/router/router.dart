import 'package:flutter/material.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/auth/change_password.dart';
import 'package:meeting_scheduler/screens/auth/otp_verification.dart';
import 'package:meeting_scheduler/screens/auth/otp_verified.dart';
import 'package:meeting_scheduler/screens/auth/sign_in.dart';
import 'package:meeting_scheduler/screens/auth/sign_up.dart';
import 'package:meeting_scheduler/screens/meeting_screens/create_meeting.dart';
import 'package:meeting_scheduler/screens/home/home_screen_wrapper.dart';
import 'package:meeting_scheduler/screens/meeting_screens/view_meeting_screen.dart';
import 'package:meeting_scheduler/screens/notifications/notifications.dart';
import 'package:meeting_scheduler/screens/onboarding/onboarding_screen_wrapper.dart';
import 'package:meeting_scheduler/screens/profile/edit_profile.dart';
import 'package:meeting_scheduler/screens/widgets/success_screen.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';

class AppNavigator {
  const AppNavigator._();
  static const instance = AppNavigator._();

  //! NAVIGATE TO A PAGE WITHOUT REPLACING THE PREVIOUS PAGE.
  Future<void> navigateToPage({
    required String thePageRouteName,
    required BuildContext context,
    Object? arguments,
  }) =>
      Navigator.of(context).pushNamed(
        thePageRouteName,
        arguments: arguments,
      );

  //! NAVIGATE TO A PAGE AND REPLACE THE PREVIOUS PAGE
  Future<void> navigateToReplacementPage({
    required String thePageRouteName,
    required BuildContext context,
    Object? arguments,
  }) =>
      Navigator.of(context).pushReplacementNamed(
        thePageRouteName,
        arguments: arguments,
      );

  Future<void> pushNamedAndRemoveUntil({
    required String thePageRouteName,
    required BuildContext context,
    Object? arguments,
  }) =>
      Navigator.of(context).pushNamedAndRemoveUntil(
        thePageRouteName,
        (route) => false,
        arguments: arguments,
      );

  //! ROUTE GENERATOR
  Route<dynamic> generateRoute({required RouteSettings routeSettings}) {
    switch (routeSettings.name) {
      //! ONBOARDING SCREEN
      case AppRoutes.onboardingScreen:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const OnboardingScreenWrapper(),
        );

      //! AUTH
      case AppRoutes.signUp:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const SignUpScreen(),
        );

      case AppRoutes.signIn:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const SignInScreen(),
        );

      case AppRoutes.otpVerification:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const OTPVerification(),
        );

      case AppRoutes.otpVerified:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const OTPVerified(),
        );

      //! HOME SCREEN WRAPPER - CARRYING BOTTOM NAV BAR & HOME SCREEN PAGES
      case AppRoutes.homeScreen:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const HomeScreenWrapper(),
        );

      case AppRoutes.createMeeting:
        final arguments = routeSettings.arguments as Map<String, dynamic>?;

        if (arguments != null) {
          final isEditMeeting = arguments["isEditMeeting"] as bool;
          final meetingModel =
              arguments["meetingModel"] as ScheduledMeetingModel;

          return GetPageRoute.instance.getPageRoute(
            routeName: routeSettings.name,
            args: routeSettings.arguments,
            view: CreateMeeting(
              isEditMeeting: isEditMeeting,
              meetingModel: meetingModel,
            ),
          );
        }

        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const CreateMeeting(
            isEditMeeting: false,
          ),
        );

      case AppRoutes.viewMeeting:
        final arguments = routeSettings.arguments as Map<String, dynamic>?;
        final meeting = arguments?["meeting"] as ScheduledMeetingModel;

        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: ViewMeetingScreen(meeting: meeting),
        );

      case AppRoutes.notificationsScreen:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const NotificationsScreen(),
        );

      //!
      case AppRoutes.editProfile:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const EditProfileScreen(),
        );

      case AppRoutes.changePassword:
        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const ChangePasswordScreen(),
        );

      case AppRoutes.successScreen:
        final arguments = routeSettings.arguments as Map<String, dynamic>?;

        if (arguments != null) {
          final meetingOwner = arguments["meetingOwner"] as String;
          final meetingID = arguments["meetingID"] as String;
          final showMeetingOwner = arguments["showMeetingOwner"] as bool;

          return GetPageRoute.instance.getPageRoute(
            routeName: routeSettings.name,
            args: routeSettings.arguments,
            view: SuccessScreen(
              meetingOwner: meetingOwner,
              showMeetingOwner: showMeetingOwner,
              meetingID: meetingID,
            ),
          );
        }

        return GetPageRoute.instance.getPageRoute(
          routeName: routeSettings.name,
          args: routeSettings.arguments,
          view: const SuccessScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreenWrapper(),
        );
    }
  }
}

class GetPageRoute {
  const GetPageRoute._();
  static const instance = GetPageRoute._();

  //! GET A PAGE ROUTE
  PageRoute<MaterialPageRoute<Widget?>> getPageRoute({
    String? routeName,
    Widget? view,
    Object? args,
  }) =>
      MaterialPageRoute(
        settings: RouteSettings(name: routeName, arguments: args),
        builder: (_) => view!,
      );
}
