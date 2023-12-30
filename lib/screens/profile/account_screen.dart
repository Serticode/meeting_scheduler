import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/account_settings_item.dart';
import 'package:meeting_scheduler/screens/widgets/logout_dialogue.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const List<String> accountSettingsIcons = [
    AppImages.lock,
    AppImages.logout,
  ];

  static const List<String> titles = [
    "Change Password",
    "Logout",
  ];

  static const List<String> subtitles = [
    "Got any queries? Send us a message now",
    "Got any queries? Send us a message now",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFullName = ref.watch(userFullNameProvider);
    final userProfileImage = ref.watch(userProfileImageProvider);

    return Column(
      children: [
        AppTexts.accountSettings
            .txt(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )
            .alignCenter(),

        //!
        24.0.sizedBoxHeight,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserProfileImage(
              isAccountSettingsPage: true,
              imageURL: userProfileImage,
            ),

            //!
            const Spacer(),

            //! EDIT PROFILE BUTTON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: ShapeDecoration(
                color: AppColours.deepBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: "Edit Profile"
                  .txt12(
                    color: AppColours.white,
                  )
                  .alignCenter(),
            ).onTap(
              onTap: () {
                "Edit profile".log();
                AppNavigator.instance.navigateToPage(
                  thePageRouteName: AppRoutes.editProfile,
                  context: context,
                );
              },
            ),
          ],
        ),

        12.0.sizedBoxHeight,

        userFullName != null
            ? userFullName.txt14(fontWeight: FontWeight.w500).alignCenterLeft()
            : "Hello there!"
                .txt14(fontWeight: FontWeight.w500)
                .alignCenterLeft(),

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
          ).onTap(
            onTap: () async {
              switch (accountSettingsIcons.indexOf(icon)) {
                case 0:
                  await AppNavigator.instance.navigateToPage(
                    thePageRouteName: AppRoutes.changePassword,
                    context: context,
                  );
                case 1:
                  // ignore: use_build_context_synchronously
                  await showAdaptiveDialog(
                      context: context,
                      barrierColor: Colors.black12,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          elevation: 1.0,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          content: const LogoutDialogue(),
                        );
                      });

                default:
                  "Account Setting Item Tapped".log();
              }
            },
          ),
        ),
      ],
    );
  }
}
