import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class EmptyCalender extends ConsumerWidget {
  const EmptyCalender({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.emptyCalender).transformToScale(
            scale: 0.8,
          ),

          //!
          6.0.sizedBoxHeight,

          "You don’t have any meeting yet. \nCreate one below!".txt(
            fontSize: 16,
            color: AppColours.black50,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
