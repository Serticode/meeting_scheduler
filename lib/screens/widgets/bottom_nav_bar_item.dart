// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      height: 65.0,
      width: 60.0,
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 18.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //! ICON
          SvgPicture.asset(
            itemIcon,
            color: isSelected ? AppColours.deepBlue : null,
          ),

          //! SPACER
          6.0.sizedBoxHeight,

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
