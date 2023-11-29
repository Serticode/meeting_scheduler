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
    return Container(
      height: 300,
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
          "Oh no you’re leaving, are you sure?".txt14(),

          21.0.sizedBoxHeight,

          RegularButton(
            onTap: () => Navigator.of(context).pop(),
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
            child: "Yes, log me out"
                .txt16(fontWeight: FontWeight.w400)
                .alignCenter(),
          ),
        ],
      ),
    ).generalVerticalPadding;
  }
}
