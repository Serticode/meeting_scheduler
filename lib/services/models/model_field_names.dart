import "package:flutter/foundation.dart";

//!
//! SCHEDULED MEETING
@immutable
class ScheduledMeetingFieldNames {
  static const String ownerID = "ownerID";
  static const String meetingID = "meetingID";
  static const String fullName = "fullName";
  static const String professionOfVenueBooker = "professionOfVenueBooker";
  static const String purposeOfMeeting = "purposeOfMeeting";
  static const String numberOfExpectedParticipants =
      "numberOfExpectedParticipants";
  static const String dateOfMeeting = "dateOfMeeting";
  static const String meetingStartTime = "meetingStartTime";
  static const String meetingEndTime = "meetingEndTime";
  static const String selectedVenue = "selectedVenue";

  const ScheduledMeetingFieldNames._();
}

@immutable
class FirebaseCollectionName {
  static const String users = "Users";
  static const String meetings = "meetings";
  const FirebaseCollectionName._();
}

@immutable
class FirebaseUserFieldName {
  static const String userId = "uid";
  static const String fullName = "fullName";
  static const String email = "email";
  static const String profileImage = "profileImage";
  static const String profession = "profession";
  static const String phoneNumber = "phoneNumber";

  const FirebaseUserFieldName._();
}

@immutable
class FirestoreFileFieldNames {
  static const profileImage = "profileImage";
  const FirestoreFileFieldNames._();
}
