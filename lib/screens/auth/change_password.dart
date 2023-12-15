import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_fields.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = false.toValueNotifier;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColours.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColours.greyBlack),
        title: "Change Password".txt(
          fontSize: 21.0,
          color: AppColours.greyBlack,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),

      //!
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            21.0.sizedBoxHeight,

            "Current Password".txt14(),

            12.0.sizedBoxHeight,

            //! CURRENT PASSWORD
            _isPasswordVisible.toValueListenable(
              builder: (context, value, child) {
                return CustomTextFormField(
                  isForPassword: false,
                  hint: "Enter current password",
                  controller: _currentPassword,
                  suffixIcon: value == true
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  validator: (value) {
                    if (_currentPassword.value.text.trim().length < 6 ||
                        _currentPassword.value.text.trim().isEmpty) {
                      return "Your password cannot be empty or less than 6 characters";
                    } else {
                      return null;
                    }
                  },
                );
              },
            ),

            21.0.sizedBoxHeight,

            "New Password".txt14(),

            12.0.sizedBoxHeight,

            //! NEW PASSWORD
            _isPasswordVisible.toValueListenable(
              builder: (context, value, child) {
                return CustomTextFormField(
                  isForPassword: false,
                  hint: "Enter new password",
                  controller: _newPassword,
                  suffixIcon: value == true
                      ? const Icon(Icons.visibility)
                      : const Icon(
                          Icons.visibility_off,
                        ),
                  validator: (value) {
                    if (_newPassword.value.text.trim().length < 6 ||
                        _newPassword.value.text.trim().isEmpty) {
                      return "Your password cannot be empty or less than 6 characters";
                    } else {
                      return null;
                    }
                  },
                );
              },
            ),

            21.0.sizedBoxHeight,

            "Confirm New Password".txt14(),

            12.0.sizedBoxHeight,

            //! CONFIRM NEW PASSWORD
            _isPasswordVisible.toValueListenable(
              builder: (context, value, child) {
                return CustomTextFormField(
                  isForPassword: true,
                  hint: "Confirm new password",
                  controller: _confirmNewPassword,
                  suffixIcon: value == true
                      ? const Icon(Icons.visibility)
                      : const Icon(
                          Icons.visibility_off,
                        ),
                  validator: (value) {
                    if (_confirmNewPassword.value.text.trim() !=
                        _newPassword.value.text.trim()) {
                      return "Passwords do not match";
                    } else {
                      return null;
                    }
                  },
                );
              },
            ),

            const Spacer(),

            Builder(builder: (context) {
              final bool isLoading =
                  ref.watch(authControllerProvider).isLoading;

              return RegularButton(
                onTap: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .validateChangePassword(
                        isValidated: _formKey.currentState!.validate(),
                        currentPassword: _currentPassword.value.text.trim(),
                        newPassword: _newPassword.value.text.trim(),
                        context: context,
                      )
                      .whenComplete(() {
                    Navigator.of(context).pop();
                  });
                },
                buttonText: AppTexts.enter,
                isLoading: isLoading,
              );
            }),

            21.0.sizedBoxHeight,
          ],
        ).generalPadding.ignorePointer(
              isLoading: ref.watch(authControllerProvider).isLoading,
            ),
      ),
    );
  }
}
