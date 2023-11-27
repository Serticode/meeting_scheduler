import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final userMeetingsControllerProvider =
    AsyncNotifierProvider<UserMeetingsController, List<ScheduledMeetingModel>>(
  UserMeetingsController.new,
);

class UserMeetingsController
    extends AsyncNotifier<List<ScheduledMeetingModel>> {
  //!
  @override
  FutureOr<List<ScheduledMeetingModel>> build() => [];

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

    state.log();
  }

  Future<void> updateMeeting({
    required ScheduledMeetingModel scheduledMeeting,
  }) async {
    ScheduledMeetingModel? initialMeeting = state.value?.firstWhere(
      (element) => element.meetingID == scheduledMeeting.meetingID,
    );

    if (initialMeeting == scheduledMeeting) return;

    List<ScheduledMeetingModel>? tempList = state.value;

    tempList?.removeWhere(
      (element) => element.meetingID == scheduledMeeting.meetingID,
    );

    tempList?.add(scheduledMeeting);

    state = AsyncValue.data(tempList!);

    state.log();
  }

  Future<void> deleteMeeting({
    required ScheduledMeetingModel scheduledMeeting,
  }) async {
    state.value?.removeWhere(
      (element) => element.meetingID == scheduledMeeting.meetingID,
    );
  }
}
