import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/back_buttons.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_fields.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
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
  final TextEditingController _phoneNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? selectedCountryCode;

  @override
  Widget build(BuildContext context) {
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
                  onTap: () => Navigator.pop(context),
                ),

                32.0.sizedBoxHeight,

                //! TITLE
                AppTexts.otpVerification.txt24(
                  fontWeight: FontWeight.w700,
                ),

                12.0.sizedBoxHeight,

                //! RIDER
                (value == false
                        ? AppTexts.otpVerificationRiderPhone
                        : AppTexts.otpVerificationRider)
                    .txt14(color: AppColours.black50),

                32.0.sizedBoxHeight,

                //! PINPUT
                value == false
                    ? Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: CountryCodePicker(
                              backgroundColor: AppColours.purple,
                              searchDecoration: InputDecoration(
                                //! BORDERS
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1.2,
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1.6,
                                    color: AppColours.primaryBlue,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.6,
                                    color: AppColours.red,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.6,
                                    color: AppColours.red,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),

                              //!
                              initialSelection: "NG",
                              favorite: const ["+234", "NG"],
                              onChanged: (countryCode) =>
                                  selectedCountryCode = countryCode.dialCode!,
                              onInit: (countryCode) =>
                                  selectedCountryCode = countryCode!.dialCode,
                            ),
                          ),

                          //!
                          2.0.sizedBoxWidth,

                          //!
                          Expanded(
                            child: OTPContactFormField(
                              hint: "Enter your phone number",
                              controller: _phoneNumber,
                              validator: (value) {
                                if (value!.length < 11 || value.isEmpty) {
                                  return "Enter a valid phone number";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
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
                      ).alignCenter(),

                50.0.sizedBoxHeight,

                RegularButton(
                  onTap: () async {
                    if (value == false &&
                        selectedCountryCode != null &&
                        _formKey.currentState!.validate()) {
                      await ref
                          .read(authControllerProvider.notifier)
                          .sendVerificationCode(
                            phoneNumber:
                                "$selectedCountryCode${_phoneNumber.value.text.substring(1)}",
                            context: context,
                          )
                          .then((value) {
                        showVerificationField.value = value;
                      });
                    }

                    /* if (value) {
                      await AppNavigator.instance.navigateToPage(
                        thePageRouteName: AppRoutes.otpVerified,
                        context: context,
                      );
                    } */
                  },
                  buttonText:
                      value == false ? AppTexts.sendCode : AppTexts.verifyCode,
                  isLoading: false,
                ),

                const Spacer(),

                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: "Didn’t received code? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColours.greyBlack,
                        )),
                    TextSpan(
                      text: " Resend",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColours.purple,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => AppNavigator.instance
                            .navigateToReplacementPage(
                                thePageRouteName: AppRoutes.signUp,
                                context: context),
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
