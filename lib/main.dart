import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/screens/onboarding/onboarding_screen_wrapper.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/theme/theme.dart';

//! RIVERPOD CODE GENERATOR COMMAND
//! flutter pub run build_runner watch -d

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      ProviderScope(
        child: const MeetingScheduler().darkStatusBar(),
      ),
    ),
  );
}

class MeetingScheduler extends ConsumerWidget {
  const MeetingScheduler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppTexts.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appThemeLight,

      //! NAVIGATION
      onGenerateRoute: (settings) =>
          AppNavigator.generateRoute(routeSettings: settings),

      home: const OnboardingScreenWrapper(),
    );
  }
}
