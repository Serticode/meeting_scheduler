import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/firebase_options.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/screens/auth/sign_up.dart';
import 'package:meeting_scheduler/screens/home/home_screen_wrapper.dart';
import 'package:meeting_scheduler/screens/onboarding/onboarding_screen_wrapper.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/preferences/app_preferences.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final bool showHome = await AppPreferences.instance.getShowHome() ?? false;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      ProviderScope(
        child: MeetingScheduler(showHome: showHome).darkStatusBar(),
      ),
    ),
  );
}

class MeetingScheduler extends ConsumerWidget {
  final bool showHome;
  const MeetingScheduler({
    super.key,
    required this.showHome,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppTexts.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appThemeLight,

      //! NAVIGATION
      onGenerateRoute: (settings) =>
          AppNavigator.instance.generateRoute(routeSettings: settings),

      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authControllerProvider);

          if (authState.isLoggedIn) {
            return const HomeScreenWrapper();
          } else if (showHome) {
            return const SignUpScreen();
          } else {
            return const OnboardingScreenWrapper();
          }
        },
      ),
    );
  }
}
