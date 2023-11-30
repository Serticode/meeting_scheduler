import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_texts.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class ViewMeetingScreen extends ConsumerWidget {
  final ScheduledMeetingModel meeting;
  const ViewMeetingScreen({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: AppTexts.viewMeeting.txt(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColours.white,
      body: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: 12.0.symmetricPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColours.deepBlue.withOpacity(0.4),
        ),
        child: Column(
            children: meeting.entries
                .map(
                  (MapEntry<String, dynamic> entry) => Padding(
                    padding: 12.0.verticalPadding,
                    child: Row(children: [
                      entry.key.txt14(),
                      const Spacer(),
                      entry.value.toString().txt14()
                    ]),
                  ),
                )
                .toList()),
      ).generalPadding,
    );
  }
}
