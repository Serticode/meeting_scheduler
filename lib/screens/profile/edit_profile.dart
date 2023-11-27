import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/text_form_field.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.buttonBlue,
      appBar: AppBar(
        backgroundColor: AppColours.buttonBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColours.white),
        title: "Profile".txt(
          fontSize: 21.0,
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
                    ),

                    12.0.sizedBoxHeight,

                    "Profession".txt16(),

                    21.0.sizedBoxHeight,

                    //! PROFESSION
                    CustomTextFormField(
                      isForPassword: false,
                      hint: "Profession e.g lecturer, secretary",
                      controller: _profession,
                    ),

                    21.0.sizedBoxHeight,

                    "Email".txt16(),

                    12.0.sizedBoxHeight,

                    //! EMAIL
                    CustomTextFormField(
                      isForPassword: false,
                      hint: "Email",
                      controller: _email,
                    ),

                    21.0.sizedBoxHeight,

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
                      onTap: () {},
                      buttonText: AppTexts.enter,
                      isLoading: false,
                    ),

                    12.0.sizedBoxHeight,
                  ],
                ).generalPadding,
              ),
            ),
          ).alignBottomCenter(),

          //! TODO: KINDLY MAKE THIS RESPONSIVE
          const Positioned(
            bottom: 580,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColours.profileImageBGColour,
              child: UserProfileImage(
                isAccountSettingsPage: false,
                radius: 50.0,
                iconColour: AppColours.white,
              ),
            ),
          ),

          //!
          Positioned(
            bottom: 590,
            right: 150,
            child: SvgPicture.asset(
              AppImages.editProfilePicture,
            ),
          )
        ],
      ),
    );
  }
}
