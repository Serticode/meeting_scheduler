// ignore_for_file: avoid_public_notifier_properties
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final meetingVenueControllerProvider =
    AsyncNotifierProvider<MeetingVenueController, MeetingVenue>(
  MeetingVenueController.new,
);

class MeetingVenueController extends AsyncNotifier<MeetingVenue> {
  @override
  FutureOr<MeetingVenue> build() => MeetingVenue.venue;

  MeetingVenue? get getSelectedVenue => state.value;

  setMeetingVenue({required MeetingVenue meetingVenue}) =>
      state = AsyncValue.data(meetingVenue);

  List<MeetingVenue> get getAllMeetingVenues => MeetingVenue.values;
}
