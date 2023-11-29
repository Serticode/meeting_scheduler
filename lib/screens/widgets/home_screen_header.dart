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
    return Row(
      children: [
        //! IMAGE
        Builder(builder: (context) {
          final userProfileImage = ref.watch(userProfileImageProvider);
          return UserProfileImage(
            isAccountSettingsPage: false,
            imageURL: userProfileImage,
          );
        }),

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

        Builder(
          builder: (context) {
            final dateTime = DateTime.now();

            return "${AppUtils.getMonth(dateTime: dateTime)} ${dateTime.day}, ${dateTime.year}"
                .txt14(
              fontWeight: FontWeight.w600,
              color: AppColours.deepBlue.withOpacity(0.3),
            );
          },
        ),
      ],
    );
  }
}
