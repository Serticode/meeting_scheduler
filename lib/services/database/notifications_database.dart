import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class NotificationsModel extends MapView<String, dynamic> {
  final String type;
  final String message;
  final String notificationID;
  final String ownerID;
  final String meetingID;
  final String createdAt;

  NotificationsModel({
    required this.type,
    required this.message,
    required this.notificationID,
    required this.ownerID,
    required this.meetingID,
    required this.createdAt,
  }) : super({
          "type": type,
          "message": message,
          "notificationID": notificationID,
          "ownerID": ownerID,
          "meetingID": meetingID,
          "createdAt": createdAt,
        });

  NotificationsModel.fromJSON({
    required Map<String, dynamic> json,
  }) : this(
            type: json["type"] ?? "",
            message: json["message"] ?? "",
            notificationID: json["notificationID"] ?? "",
            ownerID: json["ownerID"] ?? "",
            meetingID: json["meetingID"] ?? "",
            createdAt: json["createdAt"] ?? "");
}

class NotificationsDatabase {
  const NotificationsDatabase._();
  static const instance = NotificationsDatabase._();

  static final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection(
    FirebaseCollectionName.notifications,
  );

  //!
  //! SAVE NOTIFICATION
  Future<bool> addNotification({
    required NotificationsModel notification,
  }) async {
    final notificationPayload = NotificationsModel(
      type: notification.type,
      message: notification.message,
      notificationID: notification.notificationID,
      ownerID: notification.ownerID,
      meetingID: notification.meetingID,
      createdAt: notification.createdAt,
    );

    try {
      await notificationsCollection.add(notificationPayload);
      return true;
    } catch (error) {
      error.toString().log();

      return false;
    }
  }

  //!
  //! TODO: FIX BELOW
  //! UPDATE NOTIFICATION
  Future<bool> updateNotification({
    required ScheduledMeetingModel meeting,
    required NotificationsModel notification,
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
      await notificationsCollection
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
}
