/* import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_venue_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class MeetingVenueSelector extends ConsumerWidget {
  const MeetingVenueSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final List<MeetingVenue> items = ref
            .read(meetingVenueControllerProvider.notifier)
            .getAllMeetingVenues;

        final AsyncValue<MeetingVenue> meetingVenue =
            ref.watch(meetingVenueControllerProvider);

        return Container(
          padding: 18.0.symmetricPadding,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<MeetingVenue>(
              isExpanded: true,
              buttonStyleData: const ButtonStyleData(
                height: 20,
                width: double.infinity,
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 60,
                padding: 21.0.symmetricPadding,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                offset: const Offset(0, 250),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all(3),
                  thumbVisibility: MaterialStateProperty.all(true),
                ),
              ),

              //!
              items: items
                  .map(
                    (MeetingVenue item) => DropdownMenuItem<MeetingVenue>(
                      value: item,
                      child: item.hallName.txt16(
                        color: AppColours.black50,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
              value: meetingVenue.value,
              onChanged: (MeetingVenue? newMeetingVenue) => ref
                  .read(meetingVenueControllerProvider.notifier)
                  .setMeetingVenue(
                    meetingVenue: newMeetingVenue ?? MeetingVenue.cit,
                  ),
            ),
          ),
        );
      },
    );
  }
}
 */