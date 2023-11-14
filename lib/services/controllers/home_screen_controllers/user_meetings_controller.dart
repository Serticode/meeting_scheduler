import 'package:meeting_scheduler/services/models/scheduled_meeting_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "user_meetings_controller.g.dart";

@Riverpod(keepAlive: true)
class UserMeetingsController extends _$UserMeetingsController {
  @override
  FutureOr<List<ScheduledMeetingModel>> build() => [];
  // AsyncValue<List<ScheduledMeetingModel>> mainState;

  ScheduledMeetingModel? getMeetingInfo({
    required ScheduledMeetingModel selectedMeeting,
  }) =>
      state.value?.firstWhere(
        (meeting) => meeting.selectedVenue == selectedMeeting.selectedVenue,
      );

  void setMeetings({
    required List<ScheduledMeetingModel> meetingVenue,
  }) =>
      state = AsyncValue.data(meetingVenue);

  Future<void> addMeeting({
    required ScheduledMeetingModel scheduledMeeting,
  }) async {
    List<ScheduledMeetingModel>? tempList = state.value;

    if (tempList?.contains(scheduledMeeting) == false) {
      tempList?.add(scheduledMeeting);
    }

    if (tempList != null) {
      state = AsyncValue.data(tempList);
    }
  }
}
