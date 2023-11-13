import 'package:meeting_scheduler/services/models/scheduled_meeting_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "user_meetings_controller.g.dart";

@riverpod
class UserMeetingsController extends _$UserMeetingsController {
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
    tempList?.add(scheduledMeeting);
    if (tempList != null) {
      state = AsyncValue.data(tempList);
    }
  }

  List<ScheduledMeetingModel>? get getAllMeetingVenues => List.generate(
        10,
        (index) => ScheduledMeetingModel(
          fullName: "Meeting $index",
          professionOfVenueBooker: "Meeting $index",
          purposeOfMeeting: "Meeting $index",
          numberOfExpectedParticipants: "Meeting $index",
          dateOfMeeting: "Meeting $index",
          meetingStartTime: "Meeting $index",
          meetingEndTime: "Meeting $index",
          selectedVenue: "Meeting $index",
        ),
      );
}
