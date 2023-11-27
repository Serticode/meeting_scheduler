import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/account_settings_item.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
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
    return Column(
      children: [
        AppTexts.accountSettings
            .txt(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )
            .alignCenter(),

        //!
        24.0.sizedBoxHeight,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                  /* navigatorKey.currentState!.push(
                    PageRouteBuilder(
                      barrierDismissible: true,
                      barrierLabel: "Go Home",
                      barrierColor: AppColours.greyBlack.withOpacity(0.2),
                      opaque: false,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColours.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ).generalPadding;
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  ); */

                  // ignore: inference_failure_on_function_invocation, use_build_context_synchronously
                  await showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        body: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColours.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //! ICON
                              CircleAvatar(
                                backgroundColor:
                                    AppColours.buttonBlue.withOpacity(0.2),
                                child: SvgPicture.asset(AppImages.logout),
                              ),

                              8.0.sizedBoxHeight,

                              //!
                              "Log Out".txt16(
                                fontWeight: FontWeight.w600,
                              ),

                              12.0.sizedBoxHeight,

                              //!
                              "Oh no you’re leaving, are you sure?".txt14(),

                              21.0.sizedBoxHeight,

                              RegularButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                buttonText: "No, cancel",
                                isLoading: false,
                              ),

                              14.0.sizedBoxHeight,

                              RegularButton(
                                onTap: () async {
                                  "Log out button pressed".log();

                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .logOut()
                                      .whenComplete(
                                        () => Navigator.of(context).pop(),
                                      );
                                },
                                buttonText: "Yes, log me out",
                                bgColour: AppColours.white,
                                isLoading: false,
                                child: "Yes, log me out"
                                    .txt16(
                                      color: AppColours.deepBlue,
                                      fontWeight: FontWeight.w400,
                                    )
                                    .alignCenter(),
                              ),
                            ],
                          ),
                        ).generalPadding,
                      );
                    },
                  );
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
