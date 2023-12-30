import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/controllers/calender_controller/calender_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';

class HomeScreenCalender extends ConsumerWidget {
  const HomeScreenCalender({super.key});
  static final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDateSelectedIndex = ref.watch(calenderControllerProvider);

    return CalendarTimeline(
      showYears: true,
      initialDate: currentDateSelectedIndex.value!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2028, 12, 31),
      onDateSelected: (date) => ref
          .read(calenderControllerProvider.notifier)
          .setDate(selectedDay: date),
      monthColor: AppColours.buttonBlue.withOpacity(0.5),
      dayColor: AppColours.buttonBlue,
      dayNameColor: AppColours.lightGrey,
      dotsColor: AppColours.lightGrey,
      activeDayColor: Colors.white,
      activeBackgroundDayColor: AppColours.deepBlue,
      selectableDayPredicate: (date) => date.day != 23,
      locale: "en",
    );
  }
}
