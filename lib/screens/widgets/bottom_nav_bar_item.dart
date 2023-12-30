// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class CustomBottomNavBarItem extends ConsumerWidget {
  final void Function() onTap;
  final String label;
  final String itemIcon;
  final bool isSelected;
  const CustomBottomNavBarItem({
    super.key,
    required this.onTap,
    required this.label,
    required this.itemIcon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60.0.h,
      width: 60.0.w,
      margin: EdgeInsets.symmetric(horizontal: 18.0.w),
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //! ICON
          SvgPicture.asset(
            itemIcon,
            color: isSelected ? AppColours.deepBlue : null,
          ),

          //! SPACER
          4.0.sizedBoxHeight,

          label.txt(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: isSelected ? 12 : 10,
            color: isSelected ? AppColours.deepBlue : AppColours.deepBlue,
          ),
        ],
      ).withHapticFeedback(
        onTap: onTap,
        feedbackType: AppHapticFeedbackType.mediumImpact,
      ),
    );
  }
}
