// ignore_for_file: avoid_public_notifier_properties
import 'package:flutter/material.dart';
import 'package:meeting_scheduler/screens/calender/calender_screen.dart';
import 'package:meeting_scheduler/screens/home/home_screen.dart';
import 'package:meeting_scheduler/screens/profile/account_screen.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final homeWrapperControllerProvider =
    AsyncNotifierProvider<HomeWrapperController, int>(
  HomeWrapperController.new,
);

class HomeWrapperController extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() => 0;

  int? get currentPageIndex => state.value;

  List<String> bottomNavBarItemNames = const [
    "Home",
    "Calender",
    "Account",
  ];

  List<String> bottomNavBarItemIcons = const [
    AppImages.home,
    AppImages.calender,
    AppImages.account,
  ];

  List<String> bottomNavBarItemIconsSolid = const [
    AppImages.homeSolid,
    AppImages.calenderSolid,
    AppImages.accountSolid,
  ];

  List<Widget> screens = const [
    HomeScreen(),
    CalenderScreen(),
    AccountScreen(),
  ];

  void updatePageIndex({
    required int currentPageIndex,
  }) =>
      state = AsyncValue.data(currentPageIndex);
}
