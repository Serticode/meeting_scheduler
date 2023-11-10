import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      height: 35.0,
      width: 35.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColours.deepBlue,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: const Icon(
        Icons.arrow_back_ios,
        color: AppColours.white,
        size: 16.0,
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
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColours.deepBlue,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: const Icon(
        Icons.arrow_back_ios,
        color: AppColours.white,
        size: 16.0,
      ).alignCenter(),
    ).onTap(
      onTap: onTap,
    );
  }
}
