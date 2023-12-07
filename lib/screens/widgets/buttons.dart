import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/screens/widgets/app_loader.dart';
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
      radius: 28.0.r,
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
  final String? buttonText;
  final double? radius;
  final double? width;
  final Widget? child;
  final Color? borderColour;
  final Color? bgColour;
  final Color? textColour;
  final bool? isLogoutDialogue;
  final bool isLoading;
  const RegularButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.isLoading,
    this.radius,
    this.width,
    this.child,
    this.feedbackType,
    this.borderColour,
    this.bgColour,
    this.textColour,
    this.isLogoutDialogue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isLoading ? 75.0.w : (MediaQuery.of(context).size.width * 0.85).w,
      height: isLoading ? 75.0.h : 55.0.h,
      padding: EdgeInsets.symmetric(
        vertical: isLoading ? 8.0.h : 16.0.h,
        horizontal: isLoading ? 10.5.w : 21.0.w,
      ),
      decoration: BoxDecoration(
          borderRadius: isLoading
              ? BorderRadius.circular(75.0.r)
              : BorderRadius.circular(radius?.r ?? 10.0.r),
          color: bgColour ?? AppColours.buttonBlue,
          border: Border.all(
            color: borderColour ?? AppColours.buttonBlue,
          )),
      child: isLoading
          ? AppLoader(isLogoutDialogue: isLogoutDialogue)
          : buttonText!
              .txt14(
                color: textColour ?? AppColours.white,
                fontWeight: FontWeight.w600,
              )
              .alignCenter(),
    ).withHapticFeedback(
      feedbackType: feedbackType,
      onTap: onTap,
    );
  }
}
