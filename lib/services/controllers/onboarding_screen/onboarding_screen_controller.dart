import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "onboarding_screen_controller.g.dart";

@riverpod
class OnboardingScreenController extends _$OnboardingScreenController {
  @override
  FutureOr<int> build() => 0;

// ignore: avoid_public_notifier_properties
  List<String> onboardingImages = [
    AppImages.onboardingImage1SVG,
    AppImages.onboardingImage2SVG,
    AppImages.onboardingImage3SVG,
    AppImages.onboardingImage4SVG,
  ];

  void resetPageIndex() => state = const AsyncValue.data(0);

  void incrementPageIndex() => state = AsyncValue.data(state.value! + 1);
}
