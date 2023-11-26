/* // ignore_for_file: avoid_public_notifier_properties
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part "meeting_venue_controller.g.dart";

@riverpod
class MeetingVenueController extends _$MeetingVenueController {
  @override
  FutureOr<MeetingVenue> build() => MeetingVenue.venue;

  MeetingVenue? get getSelectedVenue => state.value;

  setMeetingVenue({required MeetingVenue meetingVenue}) =>
      state = AsyncValue.data(meetingVenue);

  List<MeetingVenue> get getAllMeetingVenues => MeetingVenue.values;
}
 */