import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_venue_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class MeetingVenueSelector extends ConsumerWidget {
  const MeetingVenueSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<MeetingVenue> items =
        ref.read(meetingVenueControllerProvider.notifier).getAllMeetingVenues;

    final AsyncValue<MeetingVenue> meetingVenue =
        ref.watch(meetingVenueControllerProvider);

    return Container(
      padding: 18.0.symmetricPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1.2.w),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<MeetingVenue>(
          isExpanded: false,
          buttonStyleData: ButtonStyleData(
            height: 18.0.h,
            width: double.infinity,
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 60.0.h,
            padding: 21.0.symmetricPadding,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200.0.h,
            elevation: 4,
            openInterval: const Interval(0.1, 0.6, curve: Curves.easeIn),
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            offset: Offset(0.0.w, 250.0.h),
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(40.0.r),
              thickness: MaterialStateProperty.all(3.sp),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),

          //!
          items: items
              .map(
                (MeetingVenue item) => DropdownMenuItem<MeetingVenue>(
                  value: item,
                  child: item.hallName.txt14(
                    color: AppColours.black50,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .toList(),
          value: meetingVenue.value,
          onChanged: (MeetingVenue? newMeetingVenue) =>
              ref.read(meetingVenueControllerProvider.notifier).setMeetingVenue(
                    meetingVenue: newMeetingVenue ?? MeetingVenue.cit,
                  ),
        ),
      ),
    );
  }
}
