import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/services/controllers/onboarding_screen/onboarding_screen_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreenWrapper extends ConsumerWidget {
  OnboardingScreenWrapper({super.key});
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? pageNumber = ref.watch(onboardingScreenControllerProvider).value;
    return Scaffold(
      //! BODY
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! SPACER
            32.0.sizedBoxHeight,

            //! SKIP AND OTHERS
            Row(
              children: [
                Visibility(
                  visible: pageNumber != 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColours.deepBlue,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColours.white,
                      size: 14.0,
                    ).alignCenter(),
                  ),
                ),

                const Spacer(),

                //! SKIP
                AppTexts.skip.txt16(
                  fontWeight: FontWeight.w600,
                  color: AppColours.black50,
                )
              ],
            ),

            //! SPACER
            32.0.sizedBoxHeight,

            //! WELCOME TEXT
            pageNumber == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTexts.welcome.onboardingHeaderText(),

                      //! SPACER
                      12.0.sizedBoxHeight,

                      AppTexts.onboardingScreenWelcomeRider
                          .onboardingRiderText(),
                    ],
                  )
                : const SizedBox.shrink(),

            const Spacer(),

            //! IMAGE
            Consumer(
              builder: (context, ref, child) {
                return SvgPicture.asset(
                  ref
                      .read(onboardingScreenControllerProvider.notifier)
                      .onboardingImages
                      .elementAt(pageNumber!),
                  semanticsLabel: "Onboarding image 1",
                ).alignCenter();
              },
            ),

            32.0.sizedBoxHeight,

            SmoothPageIndicator(
              controller: _controller,
              count: 4,
              effect: WormEffect(
                dotHeight: 4.0,
                dotWidth: 24.0,
                dotColor: AppColours.wormGrey,
                activeDotColor: AppColours.deepBlue,
              ),
            ).alignCenter(),

            const Spacer(),

            CircleButton(
              onTap: () {
                "Circle Button Tapped".log();
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ).alignCenter(),

            const Spacer(),
          ],
        ).generalPadding,
      ),
    );
  }
}
