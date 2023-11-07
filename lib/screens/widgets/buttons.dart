import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

//!
//! CIRCLE BUTTON
class CircleButton extends ConsumerWidget {
  final void Function() onTap;
  final int? pageNumber;
  const CircleButton({
    super.key,
    required this.onTap,
    this.pageNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      backgroundColor: AppColours.primaryBlue,
      radius: 28,
      child: SvgPicture.asset(
        AppImages.arrowRight,
      ).transformToScale(
        scale: 0.8,
      ),
    ).withHapticFeedback(
      feedbackType: pageNumber != null && pageNumber == 0
          ? AppHapticFeedbackType.mediumImpact
          : null,
      onTap: onTap,
    );
  }
}


//!
//! REGULAR BUTTON