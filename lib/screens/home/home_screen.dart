import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_header.dart';
import 'package:meeting_scheduler/screens/widgets/home_screen_search_field.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:table_calendar/table_calendar.dart';

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
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.week,
          calendarStyle: CalendarStyle(
            markerSizeScale: 0.5,
            defaultTextStyle: const TextStyle(
              color: AppColours.deepBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            todayDecoration: BoxDecoration(
              color: AppColours.deepBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          headerVisible: false,
          rowHeight: 40,
          daysOfWeekHeight: 20,
        ),

        //!
        const Spacer(),

        SvgPicture.asset(AppImages.noMeetings).transformToScale(
          scale: 0.8,
        ),

        6.0.sizedBoxHeight,

        "No Meetings to search for, \nkindly create below!".txt(
          fontSize: 16,
          color: AppColours.black50,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),

        const Spacer(),
      ],
    );
  }
}
