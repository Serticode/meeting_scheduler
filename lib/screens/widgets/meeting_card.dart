import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/services/models/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class MeetingCard extends ConsumerWidget {
  final ScheduledMeetingModel meetingDetails;
  const MeetingCard({
    super.key,
    required this.meetingDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColours.buttonBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(children: [
        //! IMAGE
        Align(
          alignment: Alignment.topRight,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(14)),
            child: SvgPicture.asset(
              AppImages.meetingTopRightBG,
            ),
          ),
        ),

        //! BODY
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.0.sizedBoxHeight,

            //! VENUE - HEADER
            meetingDetails.selectedVenue!.txt24(
              fontWeight: FontWeight.w600,
              color: AppColours.white,
            ),

            24.0.sizedBoxHeight,

            "Venue: ${meetingDetails.selectedVenue!}"
                .txt14(color: AppColours.white),

            8.0.sizedBoxHeight,

            "Date: ${meetingDetails.dateOfMeeting}"
                .txt14(color: AppColours.white),

            8.0.sizedBoxHeight,

            Row(
              children: [
                "Start Time: ${meetingDetails.meetingStartTime}"
                    .txt14(color: AppColours.white),

                //!
                const Spacer(),

                "End Time: ${meetingDetails.meetingEndTime}"
                    .txt14(color: AppColours.white),
              ],
            ),

            8.0.sizedBoxHeight,
          ],
        ).generalPadding.alignCenterLeft()
      ]),
    );
  }
}
