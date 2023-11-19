// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';

class UserProfileImage extends ConsumerWidget {
  final bool isAccountSettingsPage;
  final double? radius;
  final Color? iconColour;
  const UserProfileImage({
    super.key,
    required this.isAccountSettingsPage,
    this.radius,
    this.iconColour,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      radius: radius ?? (isAccountSettingsPage ? 32 : 24),
      backgroundColor: AppColours.deepBlue.withOpacity(0.1),
      child: SvgPicture.asset(
        AppImages.accountSolid,
        color: iconColour,
      ),
    );
  }
}
