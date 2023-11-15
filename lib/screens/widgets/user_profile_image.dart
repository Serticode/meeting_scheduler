import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';

class UserProfileImage extends ConsumerWidget {
  final bool isAccountSettingsPage;
  const UserProfileImage({
    super.key,
    required this.isAccountSettingsPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      radius: isAccountSettingsPage ? 32 : 24,
      backgroundColor: AppColours.deepBlue.withOpacity(0.1),
      child: const Icon(
        Icons.person_2_outlined,
        color: AppColours.deepBlue,
      ),
    );
  }
}
