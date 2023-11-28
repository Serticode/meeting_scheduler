// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';

class UserProfileImage extends ConsumerWidget {
  final bool isAccountSettingsPage;
  final double? radius;
  final Color? iconColour;
  final String? imageURL;
  const UserProfileImage({
    super.key,
    required this.isAccountSettingsPage,
    this.imageURL,
    this.radius,
    this.iconColour,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return imageURL == null || imageURL!.isEmpty
        ? CircleAvatar(
            radius: radius ?? (isAccountSettingsPage ? 32 : 24),
            backgroundColor: AppColours.deepBlue.withOpacity(0.1),
            child: SvgPicture.asset(
              AppImages.accountSolid,
              color: iconColour,
            ),
          )
        : //! DISPLAY AWAY !
        CircleAvatar(
            radius: radius ?? (isAccountSettingsPage ? 32 : 24),
            backgroundColor: AppColours.deepBlue.withOpacity(0.1),
            backgroundImage: CachedNetworkImageProvider(imageURL!));
  }
}
