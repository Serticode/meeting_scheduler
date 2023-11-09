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

class RegularButton extends ConsumerWidget {
  final void Function() onTap;
  final AppHapticFeedbackType? feedbackType;
  final String buttonText;
  const RegularButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.feedbackType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 21.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: AppColours.buttonBlue,
      ),
      child: buttonText.txt16(color: AppColours.white).alignCenter(),
    ).generalHorizontalPadding.withHapticFeedback(
          feedbackType: feedbackType,
          onTap: onTap,
        );
  }
}
