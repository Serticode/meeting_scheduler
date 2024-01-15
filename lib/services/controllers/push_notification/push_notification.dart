import 'package:riverpod_annotation/riverpod_annotation.dart';

final fcmProvider = AsyncNotifierProvider<FCMController, String>(
  FCMController.new,
);

class FCMController extends AsyncNotifier<String> {
  //!
  @override
  FutureOr<String> build() => "";

  void setFCM({required String fcm}) => state = AsyncValue.data(fcm);
}
