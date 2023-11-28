import 'package:riverpod_annotation/riverpod_annotation.dart';

final calenderControllerProvider =
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
