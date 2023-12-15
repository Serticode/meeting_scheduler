import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class MeetingsDatabase {
  const MeetingsDatabase._();
  static const instance = MeetingsDatabase._();

  static final CollectionReference meetingCollection =
      FirebaseFirestore.instance.collection(
    FirebaseCollectionName.meetings,
  );

  //!
  //! SAVE MEETING
  Future<bool> addMeeting({
    required ScheduledMeetingModel meeting,
  }) async {
    ScheduledMeetingModel meetingPayload = ScheduledMeetingModel(
      ownerID: meeting.ownerID,
      meetingID: meeting.meetingID,
      fullName: meeting.fullName,
      professionOfVenueBooker: meeting.professionOfVenueBooker,
      purposeOfMeeting: meeting.purposeOfMeeting,
      numberOfExpectedParticipants: meeting.numberOfExpectedParticipants,
      dateOfMeeting: meeting.dateOfMeeting,
      meetingStartTime: meeting.meetingStartTime,
      meetingEndTime: meeting.meetingEndTime,
      selectedVenue: meeting.selectedVenue,
    );

    try {
      await meetingCollection.add(meetingPayload);
      return true;
    } catch (error) {
      error.toString().log();

      return false;
    }
  }

  //!
  //! SAVE MEETING
  Future<bool> updateMeeting({
    required ScheduledMeetingModel meeting,
  }) async {
    ScheduledMeetingModel meetingPayload = ScheduledMeetingModel(
      ownerID: meeting.ownerID,
      meetingID: meeting.meetingID,
      fullName: meeting.fullName,
      professionOfVenueBooker: meeting.professionOfVenueBooker,
      purposeOfMeeting: meeting.purposeOfMeeting,
      numberOfExpectedParticipants: meeting.numberOfExpectedParticipants,
      dateOfMeeting: meeting.dateOfMeeting,
      meetingStartTime: meeting.meetingStartTime,
      meetingEndTime: meeting.meetingEndTime,
      selectedVenue: meeting.selectedVenue,
    );

    try {
      await meetingCollection
          .where(
            ScheduledMeetingFieldNames.meetingID,
            isEqualTo: meeting.meetingID,
          )
          .limit(1)
          .get()
          .then((meetingInfo) async {
        if (meetingInfo.docs.isNotEmpty) {
          meetingInfo.docs.first.data()?.log();
          await meetingInfo.docs.first.reference.update(meetingPayload);
          return true;
        }
      });

      return true;
    } catch (error) {
      error.toString().log();

      return false;
    }
  }

  //!
  //!
  Future<bool> deleteMeeting({
    required String meetingID,
    required String ownerID,
  }) async {
    try {
      QuerySnapshot meetingInfo = await meetingCollection
          .where(ScheduledMeetingFieldNames.meetingID, isEqualTo: meetingID)
          .where(ScheduledMeetingFieldNames.ownerID, isEqualTo: ownerID)
          .limit(1)
          .get();

      if (meetingInfo.docs.isNotEmpty) {
        DocumentReference documentReference = meetingInfo.docs.first.reference;

        await documentReference.delete();

        return true;
      } else {
        return false;
      }
    } catch (error) {
      error.toString().log();

      return false;
    }
  }
}
