import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/app_loader.dart';
import 'package:meeting_scheduler/screens/widgets/back_buttons.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_fields.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/controllers/auth/create_account_controller.dart';
import 'package:meeting_scheduler/services/controllers/auth/otp_controller.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/constants.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends ConsumerStatefulWidget {
  const OTPVerification({super.key});

  @override
  ConsumerState<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends ConsumerState<OTPVerification> {
  final ValueNotifier<bool> showVerificationField = false.toValueNotifier;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _emailController.value = TextEditingValue(
      text: ref.read(createAccountControllerProvider).email,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonLoading = ref.watch(otpControllerProvider);
    final createAccountDetails = ref.read(createAccountControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),

      //!
      body: showVerificationField.toValueListenable(
        builder: (context, value, child) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.0.sizedBoxHeight,

                AuthBackButton(
                  onTap: () {
                    if (showVerificationField.value == true) {
                      showVerificationField.value = false;
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),

                32.0.sizedBoxHeight,

                //! TITLE
                AppTexts.otpVerification.txt16(
                  fontWeight: FontWeight.w700,
                ),

                12.0.sizedBoxHeight,

                //! RIDER
                (value == false
                        ? AppTexts.otpVerificationRiderPhone
                        : AppTexts.otpVerificationRider)
                    .txt12(color: AppColours.black50),

                32.0.sizedBoxHeight,

                //! PINPUT
                value == false
                    ? Expanded(
                        child: OTPContactFormField(
                          hint: "Email",
                          controller: _emailController,
                        ),
                      )

                    //!
                    : Pinput(
                        autofocus: true,
                        defaultPinTheme:
                            AppConstants.otpVerificationDefaultPinTheme,
                        focusedPinTheme: AppConstants
                            .otpVerificationDefaultPinTheme
                            .copyWith(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColours.deepBlue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        errorPinTheme: AppConstants
                            .otpVerificationDefaultPinTheme
                            .copyWith(
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
                        onCompleted: (value) async {
                          await ref
                              .read(otpControllerProvider.notifier)
                              .verifyOTP(
                                otp: value,
                              )
                              .then((value) async {
                            if (value) {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .validateSignUp(
                                    context: context,
                                    isValidated: true,
                                    fullName: createAccountDetails.fullName,
                                    email: createAccountDetails.email,
                                    password: createAccountDetails.password,
                                  )
                                  .whenComplete(() async {
                                final user = ref.read(userIdProvider);
                                if (user != null && user.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: "You have been logged in".txt12(
                                        color: AppColours.white,
                                      ),
                                      backgroundColor: AppColours.buttonBlue,
                                    ),
                                  );

                                  await Future.delayed(
                                      const Duration(milliseconds: 1200));

                                  // ignore: use_build_context_synchronously
                                  AppNavigator.instance.navigateToPage(
                                    thePageRouteName: AppRoutes.homeScreen,
                                    context: context,
                                  );
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: "Invalid OTP".txt12(
                                    color: AppColours.white,
                                  ),
                                  backgroundColor: AppColours.buttonBlue,
                                ),
                              );
                            }
                          });
                        },
                      ).alignCenter(),

                50.0.sizedBoxHeight,

                RegularButton(
                  onTap: () async {
                    if (value == false) {
                      await ref
                          .read(otpControllerProvider.notifier)
                          .initConfig(
                            userEmail: _emailController.value.text.trim(),
                          )
                          .whenComplete(
                            () async => await ref
                                .read(otpControllerProvider.notifier)
                                .sendOTP()
                                .then((value) async {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        "OTP Sent, check your email.".txt12(
                                      color: AppColours.white,
                                    ),
                                    backgroundColor: AppColours.buttonBlue,
                                  ),
                                );
                                showVerificationField.value = value;
                              }
                            }),
                          );
                    } else {
                      await ref
                          .read(authControllerProvider.notifier)
                          .validateSignUp(
                            context: context,
                            isValidated: true,
                            fullName: createAccountDetails.fullName,
                            email: createAccountDetails.email,
                            password: createAccountDetails.password,
                          )
                          .whenComplete(() {
                        final user = ref.read(userIdProvider);
                        if (user != null && user.isNotEmpty) {
                          AppNavigator.instance.navigateToPage(
                            thePageRouteName: AppRoutes.homeScreen,
                            context: context,
                          );
                        }
                      });
                    }
                  },
                  buttonText: buttonLoading
                      ? null
                      : value == false
                          ? AppTexts.sendCode
                          : AppTexts.verifyCode,
                  isLoading: buttonLoading,
                  child: buttonLoading
                      ? const AppLoader(
                          isLogoutDialogue: false,
                        )
                      : null,
                ).alignCenter(),

                const Spacer(),

                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: "Didn’t received code? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColours.greyBlack,
                        )),
                    TextSpan(
                      text: " Resend",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColours.purple,
                        fontSize: 12,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async => await ref
                                .read(otpControllerProvider.notifier)
                                .sendOTP()
                                .then((value) async {
                              if (value) {
                                showVerificationField.value = value;
                              }
                            }),
                    ),
                  ]),
                ).alignCenter().withHapticFeedback(
                      onTap: null,
                      feedbackType: AppHapticFeedbackType.mediumImpact,
                    ),

                12.0.sizedBoxHeight,
              ],
            ).generalPadding,
          );
        },
      ),
    );
  }
}
