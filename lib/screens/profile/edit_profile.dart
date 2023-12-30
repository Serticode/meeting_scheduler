import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_fields.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/services/models/auth/user_model.dart';
import 'package:meeting_scheduler/services/upload_image/helper/upload_image_helper.dart';
import 'package:meeting_scheduler/services/upload_image/upload_image_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _profession = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
      (timeStamp) => updateNeededValues(
          userData: ref.watch(userInfoControllerProvider).value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColours.buttonBlue,
      appBar: AppBar(
        backgroundColor: AppColours.buttonBlue,
        iconTheme: const IconThemeData(color: AppColours.white),
        title: "Profile".txt(
          fontSize: 16.0,
          color: AppColours.white,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 629,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColours.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),

            //!
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      60.0.sizedBoxHeight,

                      "Name".txt16(),

                      12.0.sizedBoxHeight,

                      //! FULL NAME
                      CustomTextFormField(
                        isForPassword: false,
                        hint: "Full Name",
                        controller: _fullName,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (_fullName.value.text.trim().isEmpty) {
                            return null;
                          } else if (_fullName.value.text
                                  .trim()
                                  .split(" ")
                                  .length <
                              2) {
                            return "Enter a Last and First name";
                          } else {
                            return null;
                          }
                        },
                      ),

                      24.0.sizedBoxHeight,

                      "Profession".txt16(),

                      12.0.sizedBoxHeight,

                      //! PROFESSION
                      CustomTextFormField(
                        isForPassword: false,
                        hint: "Profession e.g lecturer, secretary",
                        controller: _profession,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (_profession.value.text.trim().isEmpty) {
                            return "Enter a profession";
                          } else {
                            return null;
                          }
                        },
                      ),

                      24.0.sizedBoxHeight,

                      "Email".txt16(),

                      12.0.sizedBoxHeight,

                      //! EMAIL
                      CustomTextFormField(
                        isForPassword: false,
                        hint: "Email",
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!_email.value.text.trim().contains("@")) {
                            return "Enter a valid email";
                          } else {
                            return null;
                          }
                        },
                      ),

                      24.0.sizedBoxHeight,

                      "Phone Number".txt16(),

                      12.0.sizedBoxHeight,

                      //! PROFESSION
                      CustomTextFormField(
                        isForPassword: false,
                        hint: "Phone Number",
                        controller: _phoneNumber,
                      ),

                      32.0.sizedBoxHeight,

                      //!
                      RegularButton(
                        onTap: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .validateProfileUpdate(
                                isValidated: _formKey.currentState!.validate(),
                                fullName: _fullName.value.text.trim(),
                                email: _email.value.text.trim(),
                                profession: _profession.value.text.trim(),
                                phoneNumber: _phoneNumber.value.text.trim(),
                                context: context,
                              )
                              .then((value) {
                            _fullName.clear();
                            _email.clear();
                            _profession.clear();
                            _phoneNumber.clear();
                          }).whenComplete(() {
                            updateNeededValues(
                              userData:
                                  ref.read(userInfoControllerProvider).value,
                            );
                          });
                        },
                        buttonText: AppTexts.enter,
                        isLoading: isLoading,
                      ).alignCenter(),
                    ],
                  ).generalPadding,
                ),
              ),
            ),
          ).alignBottomCenter(),

          Positioned(
              bottom: 580,
              child: Builder(builder: (context) {
                final bool isLoading = ref.watch(uploadImageProvider);
                final String? userProfileImage =
                    ref.watch(userProfileImageProvider);

                return isLoading
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColours.profileImageBGColour,
                        child: SpinKitWaveSpinner(
                          color: AppColours.white,
                          trackColor: AppColours.primaryBlue.withOpacity(0.7),
                          waveColor: AppColours.deepBlue.withOpacity(0.5),
                          size: 65,
                        ).alignCenter(),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColours.profileImageBGColour,
                        child: UserProfileImage(
                          isAccountSettingsPage: false,
                          radius: 50.0,
                          iconColour: AppColours.white,
                          imageURL: userProfileImage,
                        ),
                      );
              }).onTap(onTap: () async {
                await UploadImageHelper.pickImage().then((profilePhoto) async {
                  if (profilePhoto == null) {
                    "Select profile photo aborted".log();
                    return;
                  } else {
                    await ref
                        .read(uploadImageProvider.notifier)
                        .uploadProfilePhoto(
                          userId: ref.read(userIdProvider)!,
                          profilePhoto: profilePhoto,
                          fileType: FileType.image,
                          loggedInUser:
                              ref.read(userInfoControllerProvider).value!,
                        );
                  }
                });
              })),

          //!
          Positioned(
            bottom: 590,
            right: Platform.isIOS ? 160 : 140,
            child: SvgPicture.asset(
              AppImages.editProfilePicture,
            ),
          )
        ],
      ).ignorePointer(
        isLoading: ref.watch(uploadImageProvider),
      ),
    );
  }

  void updateNeededValues({required UserModel? userData}) {
    if (userData != null) {
      _fullName.value = TextEditingValue(text: userData.fullName ?? "");
      _profession.value = TextEditingValue(text: userData.profession ?? "");
      _email.value = TextEditingValue(text: userData.email ?? "");
      _phoneNumber.value = TextEditingValue(text: userData.phoneNumber ?? "");
    }
  }
}
