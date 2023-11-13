//! ALAS! LET THE THEMING BEGIN!
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';

class AppTheme {
  //! ELEVATED BUTTON TEXT THEME
  /* static TextStyle appButtonTextTheme = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.w500,
    color: AppColours.white,
    fontSize: 14.0.sp,
  ); */

  //! APP DATE RANGE PICKER THEME
  static final ThemeData dateRangePickerTheme = ThemeData(
    platform: Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColours.buttonBlue),
  );

  //! APP THEME - LIGHT
  static ThemeData get appThemeLight => ThemeData(
        //! HOW PAGES TRANSITION BETWEEN EACH OTHER
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          for (final platform in TargetPlatform.values)
            //platform: const OpenUpwardsPageTransitionsBuilder()
            platform: CustomFadeTransitionBuilder(),
        }),

        //! ENSURING THAT THE DENSITY OF ELEMENTS ACROSS THE APP, MATCHES THE PLATFORM
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: false,

        scaffoldBackgroundColor: AppColours.scaffoldBGColour,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColours.scaffoldBGColour,
          elevation: 0.0,
          iconTheme: IconThemeData(
            size: 18.0,
          ),
        ),
      );
}

//! ALL BASIC TRANSITIONS WRITTEN BELOW WERE TO TEST OUT DIFFERENT POSSIBLE
//! PAGE TRANSITIONS.
//! THE INITIAL TRANSITION WAS CHOSEN.
//! THE CODES BELOW WILL BE LEFT HERE FOR REFERENCE
class CustomFadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: child,
    );
  }
}

class CustomSlideTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
          .animate(animation),
      child: child,
    );
  }
}

class CustomScaleTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      child: child,
    );
  }
}
