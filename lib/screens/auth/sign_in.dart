import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_field.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final ValueNotifier<bool> isChecked = false.toValueNotifier;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                height: 120,
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

              AppTexts.login.txt(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),

              36.0.sizedBoxHeight,

              //! EMAIL
              CustomTextFormField(
                isForPassword: false,
                hint: "Enter your email",
                controller: _email,
                prefixIcon: const Icon(
                  Icons.email_rounded,
                  size: 18,
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
                    prefixIcon: const Icon(
                      Icons.lock,
                      size: 18,
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
                      .authenticateLogin(
                        context: context,
                        isValidated: _formKey.currentState!.validate(),
                        email: _email.value.text.trim(),
                        password: _password.value.text.trim(),
                      ),
                  buttonText: AppTexts.login,
                  isLoading: isLoading,
                );
              }),

              32.0.sizedBoxHeight,
            ],
          ).generalPadding.ignorePointer(
                isLoading: ref.watch(authControllerProvider).isLoading,
              ),
        ),
      ),
    );
  }
}
