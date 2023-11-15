import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class AccountSettingsItem extends ConsumerWidget {
  final String icon;
  final String title;
  final String subtitle;
  const AccountSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColours.buttonBlue.withOpacity(0.2),
            child: SvgPicture.asset(icon),
          ),

          12.0.sizedBoxWidth,

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title.txt(fontSize: 18.0),

              6.0.sizedBoxHeight,

              //!
              subtitle.txt(
                fontSize: 12.0,
                color: AppColours.black50,
              )
            ],
          ),

          const Spacer(),

          //!
          const Icon(
            Icons.arrow_forward_ios,
            size: 14.0,
          ),
        ],
      ),
    );
  }
}
