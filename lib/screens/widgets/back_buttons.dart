import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

//!
//! AUTH BACK BUTTON
class AuthBackButton extends ConsumerWidget {
  final void Function() onTap;
  const AuthBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 30.0.h,
      width: 30.0.w,
      alignment: Alignment.center,
      padding: EdgeInsets.all(4.0.sp),
      decoration: BoxDecoration(
        color: AppColours.deepBlue,
        borderRadius: BorderRadius.circular(4.0.r),
      ),
      child: const Icon(
        Icons.arrow_back_ios,
        color: AppColours.white,
        size: 14,
      ).alignCenter(),
    ).onTap(
      onTap: onTap,
    );
  }
}

//!
//! REGULAR BACK BUTTON
class RegularBackButton extends ConsumerWidget {
  final void Function() onTap;
  const RegularBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(12.0.sp),
      decoration: BoxDecoration(
        color: AppColours.deepBlue,
        borderRadius: BorderRadius.circular(4.0.r),
      ),
      child: const Icon(
        Icons.arrow_back_ios,
        color: AppColours.white,
      ).alignCenter(),
    ).onTap(
      onTap: onTap,
    );
  }
}
