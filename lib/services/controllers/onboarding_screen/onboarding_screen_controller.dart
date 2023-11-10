// ignore_for_file: avoid_public_notifier_properties
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "onboarding_screen_controller.g.dart";

@riverpod
class OnboardingScreenController extends _$OnboardingScreenController {
  @override
  FutureOr<int> build() => 0;

  List<String> onboardingImages = const [
    AppImages.onboardingImage1SVG,
    AppImages.onboardingImage2SVG,
    AppImages.onboardingImage3SVG,
    AppImages.onboardingImage4SVG,
  ];

  List<String> onboardingTextsHeader = const [
    AppTexts.appName,
    AppTexts.onboardingScreenEasyVenue,
    AppTexts.onboardingScreenMeetingScheduler,
    AppTexts.joinUs,
  ];

  List<String> onboardingTextsRider = const [
    AppTexts.appName,
    AppTexts.onboardingScreenEasyVenueRider,
    AppTexts.onboardingScreenMeetingSchedulerRider,
    AppTexts.joinUsRider,
  ];

  void resetPageIndex() => {
        state = const AsyncValue.data(0),
        "Resetting page index".log(),
      };

  void decrementPageIndex() => state = AsyncValue.data(state.value! - 1);

  void incrementPageIndex() {
    if (state.value == 3) {
      state = const AsyncValue.data(0);
    } else {
      state = AsyncValue.data(state.value! + 1);
    }
  }
}
