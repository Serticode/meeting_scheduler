import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class HomeScreenHeader extends ConsumerWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTime = DateTime.now();
    return Row(
      children: [
        //! IMAGE
        const UserProfileImage(
          isAccountSettingsPage: false,
        ),

        //!
        12.0.sizedBoxWidth,

        //! GREETING
        Builder(
          builder: (context) {
            final userDisplayName = ref.watch(userDisplayNameProvider);

            return userDisplayName != null
                ? userDisplayName.split(" ").first.txt14(
                      fontWeight: FontWeight.w700,
                    )
                : "Hello!".txt14(
                    fontWeight: FontWeight.w700,
                  );
          },
        ),

        const Spacer(),

        // ignore: lines_longer_than_80_chars
        "${AppUtils.getMonth(dateTime: dateTime)} ${dateTime.day}, ${dateTime.year}"
            .txt14(
          fontWeight: FontWeight.w600,
          color: AppColours.deepBlue.withOpacity(0.3),
        ),

        //!
        12.0.sizedBoxWidth,

        Container(
          width: 1,
          height: 40,
          color: AppColours.black50,
        ),

        //!
        12.0.sizedBoxWidth,

        SvgPicture.asset(AppImages.notifications).onTap(
          onTap: () {
            AppNavigator.instance.navigateToPage(
              thePageRouteName: AppRoutes.notificationsScreen,
              context: context,
            );
          },
        ),
      ],
    );
  }
}
