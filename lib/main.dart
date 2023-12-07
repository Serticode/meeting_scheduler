import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meeting_scheduler/firebase_options.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/screens/auth/sign_in.dart';
import 'package:meeting_scheduler/screens/home/home_screen_wrapper.dart';
import 'package:meeting_scheduler/screens/onboarding/onboarding_screen_wrapper.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/preferences/app_preferences.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';
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
        onGenerateRoute: (settings) =>
            AppNavigator.instance.generateRoute(routeSettings: settings),

        home: FlutterSplashScreen.fadeIn(
          useImmersiveMode: true,
          backgroundColor: AppColours.splashScreen,
          childWidget: SizedBox(
            height: 200.0.h,
            width: 200.0.w,
            child: Image.asset(AppImages.splashScreen).fadeInFromBottom(),
          ),
          duration: const Duration(seconds: 2),
          animationDuration: const Duration(milliseconds: 700),
          animationCurve: Curves.easeIn,
          nextScreen: Consumer(
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
          ),
        ),
      ),
    );
  }
}
