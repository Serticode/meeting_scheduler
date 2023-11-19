import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class OTPVerified extends ConsumerWidget {
  const OTPVerified({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: Column(
        children: [
          const Spacer(),

          //! IMAGE
          SvgPicture.asset(
            AppImages.verificationSuccessful,
          ).alignCenter().fadeInFromBottom(
                delay: const Duration(
                  milliseconds: 200,
                ),
              ),

          12.0.sizedBoxHeight,

          AppTexts.verified
              .txt24(
                fontWeight: FontWeight.w700,
              )
              .fadeInFromBottom(
                delay: const Duration(
                  milliseconds: 300,
                ),
              ),

          12.0.sizedBoxHeight,

          AppTexts.verifiedRider
              .txt16(
                color: AppColours.black50,
              )
              .fadeInFromBottom(
                delay: const Duration(
                  milliseconds: 400,
                ),
              ),

          75.0.sizedBoxHeight,

          RegularButton(
            onTap: () => AppNavigator.instance.navigateToPage(
              thePageRouteName: AppRoutes.homeScreen,
              context: context,
            ),
            buttonText: AppTexts.enter,
          ).fadeInFromBottom(
            delay: const Duration(
              milliseconds: 500,
            ),
          ),

          const Spacer(),
        ],
      ).generalPadding,
    );
  }
}
