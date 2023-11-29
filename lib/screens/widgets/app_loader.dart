import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class AppLoader extends ConsumerWidget {
  final bool? isLogoutDialogue;
  const AppLoader({
    super.key,
    this.isLogoutDialogue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isLogoutDialogue != null && isLogoutDialogue == true
        ? SpinKitWaveSpinner(
            color: AppColours.deepBlue,
            trackColor: AppColours.deepBlue.withOpacity(0.7),
            waveColor: AppColours.deepBlue.withOpacity(0.5),
            size: 65,
          ).alignCenter()
        : SpinKitWaveSpinner(
            color: AppColours.white,
            trackColor: AppColours.white.withOpacity(0.7),
            waveColor: AppColours.white.withOpacity(0.5),
            size: 65,
          ).alignCenter();
  }
}
