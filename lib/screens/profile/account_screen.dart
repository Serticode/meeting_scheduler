import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/account_settings_item.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  final List<String> accountSettingsIcons = const [
    AppImages.lock,
    AppImages.logout,
  ];

  final List<String> titles = const [
    "Change Password",
    "Logout",
  ];

  final List<String> subtitles = const [
    "Got any queries? Send us a message now",
    "Got any queries? Send us a message now",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppTexts.accountSettings
            .txt(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            )
            .alignCenter(),

        //!
        24.0.sizedBoxHeight,

        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const UserProfileImage(
                    isAccountSettingsPage: true,
                  ),
                  12.0.sizedBoxHeight,
                  "Mike Ayodeji".txt16(
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              //!
              const Spacer(),

              //! EDIT PROFILE BUTTON
              Container(
                width: 120,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: ShapeDecoration(
                  color: AppColours.deepBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: "Edit Profile"
                    .txt12(
                      color: AppColours.white,
                    )
                    .alignCenter(),
              ).onTap(
                onTap: () {
                  "Edit profile".log();
                  AppNavigator.navigateToPage(
                    thePageRouteName: AppRoutes.editProfile,
                    context: context,
                  );
                },
              )
            ]),

        //!
        24.0.sizedBoxHeight,

        const Divider(),

        //!
        12.0.sizedBoxHeight,

        ...accountSettingsIcons.map(
          (icon) => AccountSettingsItem(
            icon: icon,
            title: titles.elementAt(accountSettingsIcons.indexOf(icon)),
            subtitle: subtitles.elementAt(accountSettingsIcons.indexOf(icon)),
          ),
        )
      ],
    );
  }
}
