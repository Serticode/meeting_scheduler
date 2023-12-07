import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_fields.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/controllers/onboarding_screen/onboarding_screen_controller.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final ValueNotifier<bool> isChecked = false.toValueNotifier;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(onboardingScreenControllerProvider.notifier).resetPageIndex();
    });
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //! LOGO
              SizedBox(
                height: 120.0.h,
                width: 130.0.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //! BG
                    SvgPicture.asset(
                      AppImages.logoBG,
                      semanticsLabel: "Logo",
                    ),

                    //! LOGO
                    Image.asset(
                      AppImages.logo,
                      scale: 1.2,
                    ),
                  ],
                ),
              ).alignCenter(),

              12.0.sizedBoxHeight,

              AppTexts.createAccount.txt(
                fontSize: 18.0.sp,
                fontWeight: FontWeight.w500,
              ),

              36.0.sizedBoxHeight,

              //! FULL NAME
              CustomTextFormField(
                isForPassword: false,
                hint: "Full name",
                controller: _fullName,
                prefixIcon: Icon(
                  Icons.person,
                  size: 18.0.sp.sp,
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (_fullName.value.text.trim().split(" ").length < 2) {
                    return "Enter a Last and First name";
                  } else {
                    return null;
                  }
                },
              ),

              21.0.sizedBoxHeight,

              //! EMAIL
              CustomTextFormField(
                isForPassword: false,
                hint: "Enter your email",
                controller: _email,
                prefixIcon: Icon(
                  Icons.email_rounded,
                  size: 18.0.sp,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!_email.value.text.trim().contains("@")) {
                    return "Enter a valid email";
                  } else {
                    return null;
                  }
                },
              ),

              21.0.sizedBoxHeight,

              //! PASSWORD
              isChecked.toValueListenable(
                builder: (context, value, child) {
                  return CustomTextFormField(
                    isForPassword: false,
                    isPasswordVisible: !value,
                    hint: "Enter your password",
                    controller: _password,
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 18.0.sp,
                    ),
                    suffixIcon: value
                        ? const Icon(Icons.visibility)
                        : const Icon(
                            Icons.visibility_off,
                          ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (_password.value.text.trim().length < 5) {
                        return "Password cannot be less than 6 characters";
                      } else {
                        return null;
                      }
                    },
                  );
                },
              ),

              21.0.sizedBoxHeight,

              //! CONFIRM PASSWORD
              isChecked.toValueListenable(
                builder: (context, value, child) {
                  return CustomTextFormField(
                    isForPassword: false,
                    isPasswordVisible: !value,
                    hint: "Confirm your password",
                    controller: _confirmPassword,
                    prefixIcon: Icon(
                      Icons.lock,
                      size: 18.0.sp,
                    ),
                    suffixIcon: value
                        ? const Icon(Icons.visibility)
                        : const Icon(
                            Icons.visibility_off,
                          ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (_password.value.text.trim() !=
                          _confirmPassword.value.text.trim()) {
                        return "Passwords do not match";
                      } else {
                        return null;
                      }
                    },
                  );
                },
              ),

              32.0.sizedBoxHeight,

              //! SHOW PASSWORD && FORGOT PASSWORD
              Row(
                children: [
                  //! CHECK BOX
                  isChecked.toValueListenable(
                    builder: (context, value, child) {
                      return Checkbox.adaptive(
                        activeColor: AppColours.buttonBlue,
                        side: BorderSide(
                          color: isChecked.value
                              ? AppColours.primaryBlue
                              : AppColours.buttonBlue,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        semanticLabel: "Show password checkbox",
                        value: value,
                        onChanged: (value) {
                          isChecked.value = value ?? false;
                        },
                      );
                    },
                  ),

                  AppTexts.showPassword.txt16(),

                  const Spacer(),

                  AppTexts.forgotPassword.txt16().onTap(
                        onTap: () {},
                      ),
                ],
              ),

              32.0.sizedBoxHeight,

              //! BUTTON
              Builder(builder: (context) {
                final bool isLoading =
                    ref.watch(authControllerProvider).isLoading;

                return RegularButton(
                  onTap: () async => await ref
                      .read(authControllerProvider.notifier)
                      .validateSignUp(
                        context: context,
                        isValidated: _formKey.currentState!.validate(),
                        fullName: _fullName.value.text.trim(),
                        email: _email.value.text.trim(),
                        password: _password.value.text.trim(),
                      )
                      .whenComplete(() {
                    final user = ref.read(userIdProvider);
                    if (user != null && user.isNotEmpty) {
                      AppNavigator.instance.pushNamedAndRemoveUntil(
                        thePageRouteName: AppRoutes.otpVerification,
                        context: context,
                      );
                    }
                  }),
                  buttonText: AppTexts.createAccount,
                  isLoading: isLoading,
                );
              }),

              32.0.sizedBoxHeight,

              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0.sp,
                        color: AppColours.greyBlack,
                      )),
                  TextSpan(
                    text: " Login now",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColours.purple,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => AppNavigator.instance
                          .navigateToReplacementPage(
                              thePageRouteName: AppRoutes.signIn,
                              context: context),
                  ),
                ]),
              ).withHapticFeedback(
                onTap: null,
                feedbackType: AppHapticFeedbackType.mediumImpact,
              ),
            ],
          ).generalPadding.ignorePointer(
                isLoading: ref.watch(authControllerProvider).isLoading,
              ),
        ),
      ),
    );
  }
}
