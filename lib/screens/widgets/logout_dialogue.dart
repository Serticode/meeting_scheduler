import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/services/controllers/auth/auth_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class LogoutDialogue extends ConsumerWidget {
  const LogoutDialogue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Platform.isIOS ? Colors.transparent : Colors.white,
      elevation: 0,
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //! ICON
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColours.buttonBlue.withOpacity(0.2),
              child: SvgPicture.asset(
                AppImages.logout,
                height: 30,
              ),
            ),

            12.0.sizedBoxHeight,

            //!
            "Log Out".txt16(
              fontWeight: FontWeight.w600,
            ),

            12.0.sizedBoxHeight,

            //!
            "Oh no you’re leaving, are you sure?"
                .txt12(textAlign: TextAlign.center),

            21.0.sizedBoxHeight,

            SizedBox(
              height: 48,
              child: RegularButton(
                onTap: () => Navigator.of(context).pop(),
                buttonText: "No, cancel",
                isLoading: false,
              ),
            ),

            14.0.sizedBoxHeight,

            SizedBox(
              height: 48,
              child: RegularButton(
                onTap: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .logOut()
                      .whenComplete(
                        () => AppNavigator.instance.pushNamedAndRemoveUntil(
                          thePageRouteName: AppRoutes.signIn,
                          context: context,
                        ),
                      );
                },
                isLogoutDialogue: true,
                buttonText: "Yes, log me out",
                bgColour: AppColours.white,
                isLoading: ref.watch(authControllerProvider).isLoading,
                textColour: AppColours.deepBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
