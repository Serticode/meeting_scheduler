import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
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
import 'package:stacked_listview/stacked_listview.dart';

class CalenderScreen extends ConsumerWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledMeetings = ref.watch(meetingsProvider);
    final searchKeyword = ref.watch(searchFieldControllerProvider).value!;
    final dateFilter = ref.watch(calenderControllerProvider).value!;
    final dateTime = DateTime.now();

    return Column(
      children: [
        AppTexts.generalCalender
            .txt(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )
            .alignCenter(),

        //!
        12.0.sizedBoxHeight,

        Row(
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
                "${AppUtils.listOfDays.elementAt(dateTime.weekday - 1)} ".txt14(
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
        ),

        //!
        12.0.sizedBoxHeight,

        const HomeScreenSearchField(),

        //!
        12.0.sizedBoxHeight,

        const HomeScreenCalender(),

        //!
        12.0.sizedBoxHeight,

        scheduledMeetings.when(
          data: (listOfMeeting) {
            final List<ScheduledMeetingModel?> displayedList =
                ref.read(meetingsControllerProvider.notifier).getMeetings(
                      searchKeyword: searchKeyword,
                      dateFilter: dateFilter.day,
                      listOfMeeting: listOfMeeting,
                    );

            displayedList.sortList();

            return displayedList.isEmpty
                ? const EmptyCalender()
                : Expanded(
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
                        Expanded(
                          child: StackedListView(
                            padding: EdgeInsets.zero,
                            itemCount: displayedList.length,
                            reverse: true,
                            itemExtent: 220,
                            heightFactor: 0.98,
                            fadeOutFrom: 0.01,
                            physics: const BouncingScrollPhysics(),
                            builder: (context, index) {
                              final meeting = displayedList.elementAt(index);

                              return MeetingCard(meetingDetails: meeting!)
                                  .onTap(onTap: () {
                                AppNavigator.instance.navigateToPage(
                                  thePageRouteName: AppRoutes.viewMeeting,
                                  context: context,
                                  arguments: {"meeting": meeting},
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          },

          //!
          error: (error, trace) => "$error".txt16(),
          loading: () => const CircularProgressIndicator(),
        ),
      ],
    );
  }
}
