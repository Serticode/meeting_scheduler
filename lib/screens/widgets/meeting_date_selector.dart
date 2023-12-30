import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/services/controllers/create_meeting_controllers/meeting_date_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class MeetingDateSelector extends ConsumerWidget {
  const MeetingDateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DateTime?> meetingDate =
        ref.watch(meetingDateControllerProvider);

    return meetingDate.when(
      data: (data) => Container(
        padding: 18.0.symmetricPadding,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            data != null
                ? ref
                    .read(meetingDateControllerProvider.notifier)
                    .getMeetingDate
                    .txt(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Colors.black38,
                    )
                : "Date".txt(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                    color: Colors.black38,
                  ),
            const Spacer(),
            SvgPicture.asset(
              AppImages.calenderSolid,
              color: Colors.black38,
            )
          ],
        ),
      ).onTap(
        onTap: () => ref
            .read(meetingDateControllerProvider.notifier)
            .createMeetingDate(context: context),
      ),

      //!
      error: (error, trace) => Row(
        children: [
          error.toString().txt(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: Colors.black38,
              ),
          const Spacer(),
          SvgPicture.asset(
            AppImages.calenderSolid,
            color: Colors.black38,
          )
        ],
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
