import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meeting_scheduler/firebase_options.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/screens/auth/sign_in.dart';
import 'package:meeting_scheduler/screens/home/home_screen_wrapper.dart';
import 'package:meeting_scheduler/screens/notifications/notifications.dart';
import 'package:meeting_scheduler/screens/onboarding/onboarding_screen_wrapper.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/preferences/app_preferences.dart';
import 'package:meeting_scheduler/services/push_notifications/push_notifications.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';
import 'package:meeting_scheduler/theme/theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //! BG NOTIFICATION TAPPED
  PushNotifications.bgNotificationTapped();
  await PushNotifications.init();
  await PushNotifications.localNotificationsInit();
  await PushNotifications.subscribeToTopic();

  //! BG MESSAGING
  FirebaseMessaging.onBackgroundMessage((message) =>
      PushNotifications.firebaseBackgroundMessage(message: message));

  //! FORE GROUND
  PushNotifications.foreGroundMessage();

  final bool showHome = await AppPreferences.instance.getShowHome() ?? false;

  await dotenv.load(fileName: ".env");

  await SentryFlutter.init((options) {
    options.dsn = dotenv.env[SentryDSN.dsn.tag];
    options.tracesSampleRate = 1.0;
  },
      appRunner: () async => await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]).then(
            (_) => runApp(
              ProviderScope(
                child: MeetingScheduler(
                  showHome: showHome,
                ).darkStatusBar(),
              ),
            ),
          ));
}

class MeetingScheduler extends ConsumerWidget {
  final bool showHome;
  const MeetingScheduler({
    super.key,
    required this.showHome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: false,
      ensureScreenSize: true,
      builder: (context, child) => MaterialApp(
          title: AppTexts.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appThemeLight,
          supportedLocales: AppUtils.appLocales,
          localizationsDelegates: const [CountryLocalizations.delegate],

          //! NAVIGATION
          routes: {
            '/notificationScreen': (context) => const NotificationsScreen()
          },
          onGenerateRoute: (settings) =>
              AppNavigator.instance.generateRoute(routeSettings: settings),
          home: Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authControllerProvider);

              if (authState.isLoggedIn) {
                return const HomeScreenWrapper();
              } else if (showHome) {
                return const SignInScreen();
              } else {
                return const OnboardingScreenWrapper();
              }
            },
          )),
    );
  }
}
