import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class MeetingTimeSelector extends ConsumerWidget {
  const MeetingTimeSelector({
    super.key,
    required this.provider,
    required this.isStartTime,
  });
  final dynamic provider;
  final bool isStartTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startOrEnd = isStartTime ? "Start Time" : "End Time";

    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<TimeOfDay?> meetingEndTime = ref.watch(provider);

        return meetingEndTime.when(
          data: (data) => Container(
            padding: 18.0.symmetricPadding,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: data != null
                ? ref
                    .read(provider.notifier)
                    .getMeetingTime
                    .toString()
                    .txt(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black38,
                    )
                    .alignCenter()
                : startOrEnd
                    .txt(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black38,
                    )
                    .alignCenter(),
          ).onTap(
            onTap: () =>
                ref.read(provider.notifier).createMeetingTime(context: context),
          ),

          //! ERROR
          error: (error, trace) => Row(
            children: [
              error.toString().txt(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black38,
                  ),
              const Spacer(),
              const Icon(
                Icons.timer,
                size: 18,
                color: Colors.black38,
              )
            ],
          ),

          loading: () => const CircularProgressIndicator(),
        );
      },
    );
  }
}
