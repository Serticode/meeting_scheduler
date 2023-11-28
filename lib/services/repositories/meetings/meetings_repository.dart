import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/services/database/meetings_database.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

final Provider<MeetingsRepository> meetingsRepositoryProvider =
    Provider((ref) => const MeetingsRepository._());

class MeetingsRepository {
  const MeetingsRepository._() : super();
  static const MeetingsDatabase database = MeetingsDatabase.instance;

  //!
  //!  ADD MEETING
  FutureEither<MeetingUploaded> addMeeting({
    required ScheduledMeetingModel meeting,
  }) async {
    try {
      final isMeetingUploaded = await database.addMeeting(meeting: meeting);

      if (isMeetingUploaded) {
        return right(isMeetingUploaded);
      } else {
        return left(Failure(failureMessage: "Failed to upload meeting"));
      }
    } on FirebaseAuthException catch (error) {
      error.toString().log();

      return left(
        Failure(failureMessage: "Failed to register user"),
      );
    }
  }

  //!
  //!  UPDATE MEETING
  FutureEither<MeetingUploaded> updateMeeting({
    required ScheduledMeetingModel meeting,
  }) async {
    try {
      final isMeetingUploaded = await database.updateMeeting(meeting: meeting);

      if (isMeetingUploaded) {
        return right(isMeetingUploaded);
      } else {
        return left(Failure(failureMessage: "Failed to upload meeting"));
      }
    } on FirebaseAuthException catch (error) {
      error.toString().log();

      return left(
        Failure(failureMessage: "Failed to register user"),
      );
    }
  }
}
