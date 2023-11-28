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

final userMeetingsControllerProvider =
    StateNotifierProvider<UserMeetingsController, IsLoading>(
  (ref) => UserMeetingsController(controllerRef: ref),
);

class UserMeetingsController extends StateNotifier<IsLoading> {
  final Ref? _userMeetingsControllerRef;

  //! CONSTRUCTOR
  UserMeetingsController({
    required Ref? controllerRef,
  })  : _userMeetingsControllerRef = controllerRef,
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

    final Either<Failure, MeetingUploaded> result =
        await _userMeetingsControllerRef!
            .read(meetingsRepositoryProvider)
            .addMeeting(meeting: meeting);

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

    final Either<Failure, MeetingUploaded> result =
        await _userMeetingsControllerRef!
            .read(meetingsRepositoryProvider)
            .updateMeeting(meeting: meeting);

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
}

//!
//! MEETING PROVIDER
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
