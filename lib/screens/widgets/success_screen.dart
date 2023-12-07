import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/buttons.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class SuccessScreen extends ConsumerWidget {
  final String? meetingOwner;
  final String? meetingID;
  final bool? showMeetingOwner;
  const SuccessScreen({
    super.key,
    this.meetingOwner,
    this.showMeetingOwner,
    this.meetingID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          const Spacer(),

          //! IMAGE
          SvgPicture.asset(
            AppImages.verificationSuccessful,
          ).alignCenter().fadeInFromBottom(
                delay: const Duration(
                  milliseconds: 200,
                ),
              ),

          12.0.sizedBoxHeight,

          AppTexts.successful
              .txt24(
                fontWeight: FontWeight.w700,
              )
              .fadeInFromBottom(
                delay: const Duration(
                  milliseconds: 300,
                ),
              ),

          12.0.sizedBoxHeight,

          AppTexts.successfulRider
              .txt16(color: AppColours.black50, textAlign: TextAlign.center)
              .fadeInFromBottom(
                delay: const Duration(
                  milliseconds: 400,
                ),
              ),

          32.0.sizedBoxHeight,

          if (showMeetingOwner != null && showMeetingOwner == true)
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: AppColours.warmGrey),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  "$meetingOwner Meeting".txt14(),
                  const Spacer(),
                  Icon(
                    Icons.copy_rounded,
                    size: 21.sp,
                  ).onTap(
                    onTap: () => Clipboard.setData(
                      ClipboardData(
                        text: meetingID ?? "",
                      ),
                    ),
                  ),
                ],
              ).generalPadding,
            ),

          75.0.sizedBoxHeight,

          RegularButton(
            onTap: () => AppNavigator.instance.pushNamedAndRemoveUntil(
              thePageRouteName: AppRoutes.homeScreen,
              context: context,
            ),
            buttonText: AppTexts.goBack,
            isLoading: false,
          ).fadeInFromBottom(
            delay: const Duration(
              milliseconds: 500,
            ),
          ),

          const Spacer(),
        ],
      ).generalPadding,
    );
  }
}
