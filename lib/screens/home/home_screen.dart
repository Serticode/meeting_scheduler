import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_calender.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_header.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_no_meetings.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_search_field.dart';
import 'package:meeting_scheduler/screens/widgets/meeting_card.dart';
import 'package:meeting_scheduler/services/controllers/calender_controller/calender_controller.dart';
import 'package:meeting_scheduler/services/controllers/meetings_controllers/meetings_controller.dart';
import 'package:meeting_scheduler/services/controllers/search_field_controller/search_field_controller.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked_listview/stacked_listview.dart';

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
                  ? const NoMeetings()
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

                                return Slidable(
                                  key: ValueKey(displayedList.indexOf(meeting)),
                                  endActionPane: meeting?.ownerID ==
                                          ref.read(userIdProvider)
                                      ? ActionPane(
                                          motion: const DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (context) async =>
                                                  await ref
                                                      .read(
                                                          meetingsControllerProvider
                                                              .notifier)
                                                      .deleteMeeting(
                                                          meetingID: meeting!
                                                              .meetingID!,
                                                          ownerID:
                                                              meeting.ownerID!,
                                                          context: context),
                                              spacing: 12.0,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              backgroundColor: AppColours.red
                                                  .withOpacity(0.2),
                                              foregroundColor: AppColours.red,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        )
                                      : null,
                                  child: MeetingCard(
                                    meetingDetails: meeting!,
                                  ).onTap(
                                    onTap: () =>
                                        AppNavigator.instance.navigateToPage(
                                      thePageRouteName: AppRoutes.createMeeting,
                                      context: context,
                                      arguments: {
                                        "isEditMeeting": true,
                                        "meetingModel": meeting,
                                      },
                                    ),
                                  ),
                                );
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
          );
        }),
      ],
    );
  }
}
