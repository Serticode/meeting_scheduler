// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'package:meeting_scheduler/services/models/model_field_names.dart';

class ScheduledMeetingModel extends MapView<String, dynamic> {
  //! DEFINITIONS
  late String? fullName;
  late String? professionOfVenueBooker;
  late String? purposeOfMeeting;
  late String? numberOfExpectedParticipants;
  late String? dateOfMeeting;
  late String? meetingStartTime;
  late String? meetingEndTime;
  late String? selectedVenue;

  ScheduledMeetingModel({
    this.fullName,
    this.professionOfVenueBooker,
    this.purposeOfMeeting,
    this.numberOfExpectedParticipants,
    this.dateOfMeeting,
    this.meetingStartTime,
    this.meetingEndTime,
    this.selectedVenue,
  }) : super({
          ScheduledMeetingFieldNames.fullName: fullName,
          ScheduledMeetingFieldNames.professionOfVenueBooker:
              professionOfVenueBooker,
          ScheduledMeetingFieldNames.purposeOfMeeting: purposeOfMeeting,
          ScheduledMeetingFieldNames.numberOfExpectedParticipants:
              numberOfExpectedParticipants,
          ScheduledMeetingFieldNames.dateOfMeeting: dateOfMeeting,
          ScheduledMeetingFieldNames.meetingStartTime: meetingStartTime,
          ScheduledMeetingFieldNames.meetingEndTime: meetingEndTime,
          ScheduledMeetingFieldNames.selectedVenue: selectedVenue,
        });

  ScheduledMeetingModel.fromJSON({
    required Map<String, dynamic> json,
  }) : this(
          fullName: json[ScheduledMeetingFieldNames.fullName] ?? "",
          professionOfVenueBooker:
              json[ScheduledMeetingFieldNames.professionOfVenueBooker] ?? "",
          purposeOfMeeting:
              json[ScheduledMeetingFieldNames.purposeOfMeeting] ?? '',
          numberOfExpectedParticipants:
              json[ScheduledMeetingFieldNames.numberOfExpectedParticipants] ??
                  '',
          dateOfMeeting: json[ScheduledMeetingFieldNames.dateOfMeeting] ?? '',
          meetingStartTime:
              json[ScheduledMeetingFieldNames.meetingStartTime] ?? "",
          meetingEndTime: json[ScheduledMeetingFieldNames.meetingEndTime] ?? "",
          selectedVenue: json[ScheduledMeetingFieldNames.selectedVenue] ?? "",
        );

  @override
  String toString() =>
      "ScheduledMeetingModel(fullName: $fullName, professionOfVenueBooker: $professionOfVenueBooker, purposeOfMeeting: $purposeOfMeeting, numberOfExpectedParticipants: $numberOfExpectedParticipants, dateOfMeeting: $dateOfMeeting, meetingStartTime: $meetingStartTime, meetingEndTime: $meetingEndTime, selectedVenue: $selectedVenue)";

  @override
  bool operator ==(covariant ScheduledMeetingModel other) {
    if (identical(this, other)) return true;

    return other.fullName == fullName &&
        other.professionOfVenueBooker == professionOfVenueBooker &&
        other.purposeOfMeeting == purposeOfMeeting &&
        other.numberOfExpectedParticipants == numberOfExpectedParticipants &&
        other.dateOfMeeting == dateOfMeeting &&
        other.meetingStartTime == meetingStartTime &&
        other.meetingEndTime == meetingEndTime &&
        other.selectedVenue == selectedVenue;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        professionOfVenueBooker.hashCode ^
        purposeOfMeeting.hashCode ^
        numberOfExpectedParticipants.hashCode ^
        dateOfMeeting.hashCode ^
        meetingStartTime.hashCode ^
        meetingEndTime.hashCode ^
        selectedVenue.hashCode;
  }
}
