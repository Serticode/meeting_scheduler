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
  const OnboardingScreenWrapper({super.key});

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
            28.0.sizedBoxHeight,

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
                AppTexts.skip
                    .txt16(
                  fontWeight: FontWeight.w600,
                  color: AppColours.black50,
                )
                    .onTap(
                  onTap: () {
                    "Skip pressed".log();
                  },
                )
              ],
            ),

            //! SPACER
            32.0.sizedBoxHeight,

            //! WELCOME TEXT
            AnimatedContainer(
              height: pageNumber == 0 ? 65.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: pageNumber == 0
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTexts.welcome.onboardingHeaderText(),

                          //! SPACER
                          12.0.sizedBoxHeight,

                          AppTexts.onboardingScreenWelcomeRider
                              .onboardingRiderText(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const Spacer(),

            //! IMAGE
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: SvgPicture.asset(
                ref
                    .read(onboardingScreenControllerProvider.notifier)
                    .onboardingImages
                    .elementAt(
                      pageNumber ?? 0,
                    ),
                semanticsLabel: "Onboarding image $pageNumber",
              ).alignCenter(),
            ),

            32.0.sizedBoxHeight,

            //! WELCOME TEXT
            Visibility(
              visible: pageNumber != 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: pageNumber != 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ref
                              .read(onboardingScreenControllerProvider.notifier)
                              .onboardingTextsHeader
                              .elementAt(pageNumber ?? 0)
                              .txt24(
                                fontWeight: FontWeight.w700,
                              ),

                          //! SPACER
                          12.0.sizedBoxHeight,

                          ref
                              .read(onboardingScreenControllerProvider.notifier)
                              .onboardingTextsRider
                              .elementAt(pageNumber ?? 0)
                              .txt16(
                                fontWeight: FontWeight.w400,
                              ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            32.0.sizedBoxHeight,

            AnimatedSmoothIndicator(
              count: 4,
              activeIndex: pageNumber ?? 0,
              effect: WormEffect(
                dotHeight: 4.0,
                dotWidth: 24.0,
                dotColor: AppColours.wormGrey,
                activeDotColor: AppColours.deepBlue,
              ),
            ).alignCenter(),

            const Spacer(),

            pageNumber != 3
                ? CircleButton(
                    onTap: () {
                      "Circle Button Tapped".log();

                      ref
                          .read(onboardingScreenControllerProvider.notifier)
                          .incrementPageIndex();
                    },
                  ).alignCenter()
                : RegularButton(
                    buttonText: AppTexts.getStarted,
                    onTap: () {
                      "Get Started Pressed".log();

                      ref
                          .read(onboardingScreenControllerProvider.notifier)
                          .incrementPageIndex();
                    },
                  ),

            const Spacer(),
          ],
        ).generalPadding,
      ),
    );
  }
}
