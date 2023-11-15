import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class HomeScreenHeader extends ConsumerWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime dateTime = DateTime.now();
    return Row(
      children: [
        //! IMAGE
        const UserProfileImage(
          isAccountSettingsPage: false,
        ),

        //!
        12.0.sizedBoxWidth,

        //! GREETING
        "Hello, Mike!".txt14(
          fontWeight: FontWeight.w700,
        ),

        const Spacer(),

        "${AppUtils.getMonth(dateTime: dateTime)} ${dateTime.day}, ${dateTime.year}"
            .txt14(
          fontWeight: FontWeight.w600,
          color: AppColours.deepBlue.withOpacity(0.3),
        ),

        //!
        12.0.sizedBoxWidth,

        Container(
          width: 1.0,
          height: 40.0,
          color: AppColours.black50,
        ),

        //!
        12.0.sizedBoxWidth,

        const Icon(
          Icons.notifications,
        )
      ],
    );
  }
}
