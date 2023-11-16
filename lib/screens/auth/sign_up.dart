import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_field.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/services/controllers/onboarding_screen/onboarding_screen_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //! LOGO
              SizedBox(
                height: 120.0,
                width: 130,
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
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),

              36.0.sizedBoxHeight,

              //! FULL NAME
              CustomTextFormField(
                isForPassword: false,
                hint: "Full name",
                controller: _fullName,
                prefixIcon: const Icon(
                  Icons.person,
                  size: 18,
                ),
              ),

              21.0.sizedBoxHeight,

              //! EMAIL
              CustomTextFormField(
                isForPassword: false,
                hint: "Enter your email",
                controller: _email,
                prefixIcon: const Icon(
                  Icons.email_rounded,
                  size: 18,
                ),
              ),

              21.0.sizedBoxHeight,

              //! PASSWORD
              isChecked.toValueListenable(
                builder: (context, value, child) {
                  return CustomTextFormField(
                    isForPassword: false,
                    hint: "Enter your password",
                    controller: _password,
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 18,
                    ),
                    suffixIcon: value == true
                        ? const Icon(Icons.visibility)
                        : const Icon(
                            Icons.visibility_off,
                          ),
                  );
                },
              ),

              21.0.sizedBoxHeight,

              //! CONFIRM PASSWORD
              isChecked.toValueListenable(
                builder: (context, value, child) {
                  return CustomTextFormField(
                    isForPassword: false,
                    hint: "Confirm your password",
                    controller: _confirmPassword,
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 18,
                    ),
                    suffixIcon: value == true
                        ? const Icon(Icons.visibility)
                        : const Icon(
                            Icons.visibility_off,
                          ),
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
                          color: isChecked.value == true
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
                      )
                ],
              ),

              32.0.sizedBoxHeight,

              //! BUTTON
              RegularButton(
                onTap: () async {
                  "Create account pressed".log();
                  await AppNavigator.navigateToPage(
                    thePageRouteName: AppRoutes.otpVerification,
                    context: context,
                  );
                },
                buttonText: AppTexts.createAccount,
              ),

              32.0.sizedBoxHeight,

              "Already have an account?  Login now"
                  .txt16(fontWeight: FontWeight.w600),
            ],
          ).generalPadding,
        ),
      ),
    );
  }
}
