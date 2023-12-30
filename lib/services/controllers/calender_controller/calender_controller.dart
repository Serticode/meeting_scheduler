import 'package:riverpod_annotation/riverpod_annotation.dart';

final calenderControllerProvider =
    AsyncNotifierProvider<CalenderController, DateTime>(
  CalenderController.new,
);

class CalenderController extends AsyncNotifier<DateTime> {
  //!
  @override
  FutureOr<DateTime> build() => DateTime.now();

  void setDate({required DateTime selectedDay}) {
    state = AsyncValue.data(selectedDay);
  }
}

/* final calenderControllerProvider =
    AsyncNotifierProvider<CalenderController, int>(
  CalenderController.new,
);

class CalenderController extends AsyncNotifier<int> {
  //!
  @override
  FutureOr<int> build() => DateTime.now().day;

  void setDate({required int query}) {
    state = AsyncValue.data(query);
  }
}
 */