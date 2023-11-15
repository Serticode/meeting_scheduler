import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/create_meeting/create_meeting.dart';
import 'package:meeting_scheduler/screens/widgets/empty_calender.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_calender.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_search_field.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_card.dart';
import 'package:meeting_scheduler/services/controllers/home_screen_controllers/user_meetings_controller.dart';
import 'package:meeting_scheduler/services/models/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class CalenderScreen extends ConsumerWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime dateTime = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //!
        12.0.sizedBoxHeight,

        AppTexts.generalCalender
            .txt(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            )
            .alignCenter(),

        //!
        24.0.sizedBoxHeight,

        Row(
          children: [
            //! DATE
            dateTime.day.toString().txt(
                  fontSize: 44.0,
                  fontWeight: FontWeight.w500,
                ),

            6.0.sizedBoxWidth,

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "${AppUtils.listOfDays.elementAt(dateTime.weekday - 1)} ".txt14(
                  fontWeight: FontWeight.w500,
                  color: AppColours.wormGrey,
                ),
                6.0.sizedBoxHeight,
                "${AppUtils.getMonth(dateTime: dateTime)} ${dateTime.year}"
                    .txt14(
                  fontWeight: FontWeight.w500,
                  color: AppColours.wormGrey,
                )
              ],
            )
          ],
        ),

        //!
        12.0.sizedBoxHeight,

        const HomeScreenSearchField(),

        //!
        12.0.sizedBoxHeight,

        const HomeScreenCalender(),

        //!
        12.0.sizedBoxHeight,

        Consumer(
          builder: (context, ref, child) {
            final AsyncValue<List<ScheduledMeetingModel>> scheduledMeetings =
                ref.watch(userMeetingsControllerProvider);

            return scheduledMeetings.when(
              data: (listOfMeeting) {
                return listOfMeeting.isEmpty
                    ? const EmptyCalender()
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),

                                12.0.sizedBoxHeight,

                                "Your Schedule"
                                    .txt16(fontWeight: FontWeight.w600),

                                6.0.sizedBoxHeight,

                                "All your scheduled meetings or classes".txt12(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54),

                                12.0.sizedBoxHeight,

                                //! MEETING
                                ...listOfMeeting
                                    .map(
                                      (meeting) =>
                                          MeetingCard(meetingDetails: meeting)
                                              .onTap(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => CreateMeeting(
                                              meetingModel: meeting,
                                              isEditMeeting: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ]),
                        ),
                      );
              },

              //!
              error: (error, trace) => "$error".txt16(),
              loading: () => const CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}
