import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

class ViewMeetingScreen extends ConsumerWidget {
  final ScheduledMeetingModel meeting;
  const ViewMeetingScreen({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    meeting.remove("ownerID");

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColours.greyBlack, size: 18),
        title: AppTexts.viewMeeting.txt(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColours.white,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: 21.0.symmetricPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColours.deepBlue.withOpacity(0.15),
        ),
        child: Column(children: [
          ...meeting.entries
              .map(
                (entry) => Padding(
                  padding: 12.0.verticalPadding,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppUtils.fetchMeetingInfoTitle(meetingKey: entry.key)
                            .txt14(color: AppColours.black50),

                        //!
                        const Spacer(),

                        Flexible(
                          fit: FlexFit.tight,
                          child: entry.value.toString().txt14(
                                maxLines: 3,
                                textAlign: TextAlign.right,
                              ),
                        )
                      ]),
                ),
              )
              .toList(),

          const Spacer(),

          //!
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: AppColours.warmGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                "${meeting.fullName?.split(" ").take(2).toString()} Meeting"
                    .txt12(),
                const Spacer(),
                const Icon(
                  Icons.copy_rounded,
                  size: 18,
                ).onTap(
                  onTap: () async => await Clipboard.setData(
                    ClipboardData(text: meeting.meetingID ?? ""),
                  ).then(
                    (value) => AppUtils.showAppBanner(
                      title: "Success",
                      message: "Meeting ID copied successfully",
                      contentType: ContentType.success,
                      callerContext: context,
                    ),
                  ),
                ),
              ],
            ).generalPadding,
          ),
        ]),
      ).generalPadding,
    );
  }
}
