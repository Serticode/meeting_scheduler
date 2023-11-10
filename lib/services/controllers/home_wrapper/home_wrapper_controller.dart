// ignore_for_file: avoid_public_notifier_properties
import 'package:flutter/material.dart';
import 'package:meeting_scheduler/screens/calender/calender_screen.dart';
import 'package:meeting_scheduler/screens/home/home_screen.dart';
import 'package:meeting_scheduler/screens/profile/account_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "home_wrapper_controller.g.dart";

@riverpod
class HomeWrapperController extends _$HomeWrapperController {
  @override
  FutureOr<int> build() => 0;

  int? get currentPageIndex => state.value;

  List<String> bottomNavBarItemNames = const [
    "Home",
    "Calender",
    "Account",
  ];

  List<IconData> bottomNavBarItemIcons = const [
    Icons.home,
    Icons.calendar_view_day,
    Icons.person,
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
