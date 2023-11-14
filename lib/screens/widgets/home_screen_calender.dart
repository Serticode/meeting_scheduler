import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreenCalender extends ConsumerWidget {
  const HomeScreenCalender({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
        markerSizeScale: 0.5,
        defaultTextStyle: const TextStyle(
          color: AppColours.greyBlack,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        weekendTextStyle: const TextStyle(
          color: AppColours.greyBlack,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        todayDecoration: BoxDecoration(
          color: AppColours.deepBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        selectedDecoration: const BoxDecoration(
          color: AppColours.primaryBlue,
        ),
      ),
      headerVisible: false,
      rowHeight: 40,
      daysOfWeekHeight: 20,
    );
  }
}
