import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/create_meeting/create_meeting.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_calender.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_header.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_no_meetings.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_search_field.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_card.dart';
import 'package:meeting_scheduler/services/controllers/home_screen_controllers/user_meetings_controller.dart';
import 'package:meeting_scheduler/services/models/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //! HEADER
        const HomeScreenHeader(),

        //!
        21.0.sizedBoxHeight,

        //! SEARCH
        const HomeScreenSearchField(),

        //!
        21.0.sizedBoxHeight,

        //! CALENDER
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
                    ? const NoMeetings()
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
