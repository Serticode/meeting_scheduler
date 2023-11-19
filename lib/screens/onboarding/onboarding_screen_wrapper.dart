import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/back_buttons.dart';
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
    final pageNumber = ref.watch(onboardingScreenControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),
      //! BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //! SKIP AND OTHERS

          Row(
            children: [
              if (pageNumber != 0)
                AuthBackButton(
                  onTap: () => ref
                      .read(onboardingScreenControllerProvider.notifier)
                      .decrementPageIndex(),
                ),
              const Spacer(),
              if (pageNumber != 3)
                AppTexts.skip
                    .txt16(
                  fontWeight: FontWeight.w600,
                  color: AppColours.black50,
                )
                    .onTap(
                  onTap: () {
                    "Skip pressed".log();
                  },
                ),
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
          if (pageNumber != 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: pageNumber != 0
                  ? Column(
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
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                            ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

          32.0.sizedBoxHeight,

          AnimatedSmoothIndicator(
            count: 4,
            activeIndex: pageNumber ?? 0,
            effect: WormEffect(
              dotHeight: 4,
              dotWidth: 24,
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
                  onTap: () async {
                    "Get Started Pressed".log();

                    await AppNavigator.instance.navigateToReplacementPage(
                      thePageRouteName: AppRoutes.signUp,
                      context: context,
                    );
                  },
                ),

          const Spacer(),
        ],
      ).generalPadding,
    );
  }
}
