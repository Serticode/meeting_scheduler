import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();
  static final _instance = AppPreferences._();

  static AppPreferences get instance => _instance;

  final Future<SharedPreferences> pref = SharedPreferences.getInstance();

  Future<void> setShowHome({required bool showHome}) async =>
      await pref.then((value) => value.setBool("showHome", showHome));

  Future<bool?> getShowHome() async =>
      await pref.then((value) => value.getBool("showHome"));
}
