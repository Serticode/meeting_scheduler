import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/services/repositories/meetings/meetings_repository.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';

final meetingsControllerProvider =
    StateNotifierProvider<MeetingsController, IsLoading>(
  (ref) => MeetingsController(controllerRef: ref),
);

class MeetingsController extends StateNotifier<IsLoading> {
  final Ref? meetingsControllerRef;

  //! CONSTRUCTOR
  MeetingsController({
    required Ref? controllerRef,
  })  : meetingsControllerRef = controllerRef,
        super(false);

  //!
  //!
  Future<void> validateMeetingDetails(
      {required bool isValidated,
      required ScheduledMeetingModel meeting,
      required BuildContext context}) async {
    if (isValidated) {
      await addMeeting(meeting: meeting, context: context);
    }
  }

  //!
  //!
  Future<void> addMeeting({
    required ScheduledMeetingModel meeting,
    required BuildContext context,
  }) async {
    state = true;

    final Either<Failure, MeetingUploaded> result = await meetingsControllerRef!
        .read(meetingsRepositoryProvider)
        .addMeeting(
          meeting: meeting,
        );

    result.fold(
      (Failure failure) async {
        await AppUtils.showAppBanner(
          title: "Error",
          message: failure.failureMessage ??
              "Could not add meeting, please try again",
          callerContext: context,
          contentType: ContentType.failure,
        );

        state = false;
      },
      (IsLoading result) {
        result.withHapticFeedback();

        state = false;
      },
    );
  }

  //!
  //!
  Future<void> updateMeeting({
    required ScheduledMeetingModel meeting,
    required BuildContext context,
  }) async {
    state = true;

    final Either<Failure, MeetingUploaded> result = await meetingsControllerRef!
        .read(meetingsRepositoryProvider)
        .updateMeeting(
          meeting: meeting,
        );

    result.fold(
      (Failure failure) async {
        await AppUtils.showAppBanner(
          title: "Error",
          message: failure.failureMessage ??
              "Failed to update meeting info, please try again",
          callerContext: context,
          contentType: ContentType.failure,
        );

        state = false;
      },
      (MeetingUploaded result) {
        result.withHapticFeedback();

        state = false;
      },
    );
  }

  //!
  //!
  Future<void> deleteMeeting({
    required String meetingID,
    required String ownerID,
    required BuildContext context,
  }) async {
    state = true;

    final Either<Failure, MeetingDeleted> result = await meetingsControllerRef!
        .read(meetingsRepositoryProvider)
        .deleteMeeting(
          meetingID: meetingID,
          ownerID: ownerID,
        );

    result.fold(
      (Failure failure) async {
        await AppUtils.showAppBanner(
          title: "Error",
          message: failure.failureMessage ??
              "Could not delete meeting, please try again",
          callerContext: context,
          contentType: ContentType.failure,
        );

        state = false;
      },
      (MeetingUploaded result) {
        result.withHapticFeedback();

        state = false;
      },
    );
  }

  List<ScheduledMeetingModel?> getMeetings({
    required String searchKeyword,
    required int dateFilter,
    required List<ScheduledMeetingModel?> listOfMeeting,
  }) {
    if (searchKeyword.isEmpty && dateFilter == DateTime.now().day) {
      return listOfMeeting;
    } else if (searchKeyword.isNotEmpty) {
      return listOfMeeting
          .filter((meeting) => meeting!.selectedVenue!
              .toLowerCase()
              .contains(searchKeyword.toLowerCase()))
          .toList();
    } else {
      return listOfMeeting
          .filter(
            (meeting) =>
                meeting!.dateOfMeeting!
                    .split("/")
                    .first
                    .trim()
                    .compareTo(dateFilter.toString()) ==
                0,
          )
          .toList();
    }
  }
}

//!
//! MEETINGS PROVIDER
final AutoDisposeStreamProvider<List<ScheduledMeetingModel?>> meetingsProvider =
    StreamProvider.autoDispose<List<ScheduledMeetingModel?>>(
  (ref) {
    final controller = StreamController<List<ScheduledMeetingModel?>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.meetings)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      List<ScheduledMeetingModel?> meetings = [];
      final theDate = DateTime.now();
      DateTime currentDate = DateTime(theDate.year, theDate.month, theDate.day);

      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in snapshot.docs) {
        final ScheduledMeetingModel meeting = ScheduledMeetingModel.fromJSON(
          json: element.data(),
        );

        List meetingDateDetails = meeting.dateOfMeeting!.split("/").toList();
        final meetingDate = DateTime(
          int.parse(meetingDateDetails.elementAt(2).trim()),
          AppUtils.getMonthNumber(
              monthName: meetingDateDetails.elementAt(1).trim()),
          int.parse(meetingDateDetails.elementAt(0).trim()),
        );

        meetings.add(meeting);

        if (meetingDate.isAfter(currentDate) ||
            meetingDate.compareTo(currentDate) == 0) {
          meetings.add(meeting);
        }
      }

      controller.sink.add(meetings);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
