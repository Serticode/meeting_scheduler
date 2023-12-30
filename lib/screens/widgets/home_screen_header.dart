import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/widgets/user_profile_image.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class HomeScreenHeader extends ConsumerWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileImage = ref.watch(userProfileImageProvider);
    final userDisplayName = ref.watch(userDisplayNameProvider);
    final dateTime = DateTime.now();

    return Row(
      children: [
        //! IMAGE
        UserProfileImage(
          isAccountSettingsPage: false,
          imageURL: userProfileImage,
        ),

        //!
        8.0.sizedBoxWidth,

        //! GREETING
        userDisplayName != null
            ? "Hello, ${userDisplayName.split(" ").first}"
                .txt14(fontWeight: FontWeight.w500)
            : "Hello!".txt14(fontWeight: FontWeight.w500),

        const Spacer(),

        "${AppUtils.getMonth(dateTime: dateTime)} ${dateTime.day}, ${dateTime.year}"
            .txt14(
          fontWeight: FontWeight.w500,
          color: AppColours.deepBlue.withOpacity(0.3),
        ),
      ],
    );
  }
}
