import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/services/repositories/meetings/meetings_repository.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

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
  Future<void> validateMeetingDetails({
    required bool isValidated,
    required ScheduledMeetingModel meeting,
  }) async {
    if (isValidated) {
      await addMeeting(meeting: meeting);
    }
  }

  //!
  //!
  Future<void> addMeeting({
    required ScheduledMeetingModel meeting,
  }) async {
    state = true;

    final Either<Failure, MeetingUploaded> result = await meetingsControllerRef!
        .read(meetingsRepositoryProvider)
        .addMeeting(
          meeting: meeting,
        );

    result.fold(
      (Failure failure) {
        failure.failureMessage?.log();

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
  }) async {
    state = true;

    final Either<Failure, MeetingUploaded> result = await meetingsControllerRef!
        .read(meetingsRepositoryProvider)
        .updateMeeting(
          meeting: meeting,
        );

    result.fold(
      (Failure failure) {
        failure.failureMessage?.log();

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
  }) async {
    state = true;

    final Either<Failure, MeetingDeleted> result = await meetingsControllerRef!
        .read(meetingsRepositoryProvider)
        .deleteMeeting(
          meetingID: meetingID,
          ownerID: ownerID,
        );

    result.fold(
      (Failure failure) {
        failure.failureMessage?.log();

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

      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in snapshot.docs) {
        final ScheduledMeetingModel meeting = ScheduledMeetingModel.fromJSON(
          json: element.data(),
        );

        meetings.add(meeting);
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
