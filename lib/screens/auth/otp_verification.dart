import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/back_buttons.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/constants.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends ConsumerWidget {
  const OTPVerification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.0.sizedBoxHeight,

          AuthBackButton(
            onTap: () => Navigator.pop(context),
          ),

          32.0.sizedBoxHeight,

          //! TITLE
          AppTexts.otpVerification.txt24(
            fontWeight: FontWeight.w700,
          ),

          12.0.sizedBoxHeight,

          //! RIDER
          AppTexts.otpVerificationRider.txt14(
            color: AppColours.black50,
          ),

          32.0.sizedBoxHeight,

          //! PINPUT
          Pinput(
            autofocus: true,
            defaultPinTheme: AppConstants.otpVerificationDefaultPinTheme,
            focusedPinTheme:
                AppConstants.otpVerificationDefaultPinTheme.copyWith(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColours.deepBlue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            errorPinTheme: AppConstants.otpVerificationDefaultPinTheme.copyWith(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColours.red,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            pinAnimationType: PinAnimationType.fade,
            animationCurve: Curves.bounceInOut,
          ).alignCenter(),

          50.0.sizedBoxHeight,

          RegularButton(
            onTap: () async {
              "Send code - OTP VERIFICATION pressed".log();
              await AppNavigator.navigateToPage(
                thePageRouteName: AppRoutes.otpVerified,
                context: context,
              );
            },
            buttonText: AppTexts.sendCode,
          ),

          const Spacer(),

          "Didn’t received code? Resend"
              .txt16(fontWeight: FontWeight.w600)
              .alignCenter(),

          12.0.sizedBoxHeight,
        ],
      ).generalPadding,
    );
  }
}
