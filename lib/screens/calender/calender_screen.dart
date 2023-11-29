import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/create_meeting/create_meeting.dart';
import 'package:meeting_scheduler/screens/widgets/empty_calender.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_calender.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_search_field.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_card.dart';
import 'package:meeting_scheduler/services/controllers/calender_controller/calender_controller.dart';
import 'package:meeting_scheduler/services/controllers/meetings_controllers/meetings_controller.dart';
import 'package:meeting_scheduler/services/controllers/search_field_controller/search_field_controller.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class CalenderScreen extends ConsumerWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AppTexts.generalCalender
            .txt(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )
            .alignCenter(),

        //!
        24.0.sizedBoxHeight,

        Builder(builder: (context) {
          final dateTime = DateTime.now();

          return Row(
            children: [
              //! DATE
              dateTime.day.toString().txt(
                    fontSize: 44,
                    fontWeight: FontWeight.w500,
                  ),

              6.0.sizedBoxWidth,

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "${AppUtils.listOfDays.elementAt(dateTime.weekday - 1)} "
                      .txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColours.warmGrey,
                  ),
                  6.0.sizedBoxHeight,
                  "${AppUtils.getMonth(dateTime: dateTime)} ${dateTime.year}"
                      .txt14(
                    fontWeight: FontWeight.w500,
                    color: AppColours.warmGrey,
                  ),
                ],
              ),
            ],
          );
        }),

        //!
        12.0.sizedBoxHeight,

        const HomeScreenSearchField(),

        //!
        12.0.sizedBoxHeight,

        const HomeScreenCalender(),

        //!
        12.0.sizedBoxHeight,

        Builder(builder: (context) {
          final scheduledMeetings = ref.watch(meetingsProvider);
          final searchKeyword = ref.watch(searchFieldControllerProvider).value!;
          final dateFilter = ref.watch(calenderControllerProvider).value!;

          return scheduledMeetings.when(
            data: (listOfMeeting) {
              final List<ScheduledMeetingModel?> displayedList =
                  ref.read(meetingsControllerProvider.notifier).getMeetings(
                        searchKeyword: searchKeyword,
                        dateFilter: dateFilter,
                        listOfMeeting: listOfMeeting,
                      );

              displayedList.sortList();

              return displayedList.isEmpty
                  ? const EmptyCalender()
                  : Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),

                            12.0.sizedBoxHeight,

                            "Your Schedule".txt16(fontWeight: FontWeight.w600),

                            6.0.sizedBoxHeight,

                            "All your scheduled meetings or classes".txt12(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),

                            12.0.sizedBoxHeight,

                            //! MEETING
                            ...displayedList.map(
                              (meeting) =>
                                  MeetingCard(meetingDetails: meeting!).onTap(
                                onTap: () => Navigator.of(context)
                                    .push<Future<MaterialPageRoute<Widget>>>(
                                  MaterialPageRoute(
                                    builder: (context) => CreateMeeting(
                                      meetingModel: meeting,
                                      isEditMeeting: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },

            //!
            error: (error, trace) => "$error".txt16(),
            loading: () => const CircularProgressIndicator(),
          );
        }),
      ],
    );
  }
}
