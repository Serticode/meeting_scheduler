import 'package:fpdart/fpdart.dart';
import 'package:meeting_scheduler/shared/utils/failure.dart';

//! FUTURE EITHER, IS A CUSTOM TYPE DEF.
//! IT EQUATES A FUTURE OF TYPE EITHER, WHERE EITHER IS A CUSTOM TYPE DEF THAT RETURNS FAILURE RESPONSE ON THE LEFT AND SUCCESS ON THE RIGHT.
//! FAILURE TYPE HAS BEEN CUSTOM DEFINED TO RETURN JUST THE FAILURE MESSAGE.
//! SUCCESS TYPE IS DEPENDENT ON DEVELOPER DEFINITION. IT CAN BE AN INT, A BOOL OR WHATEVER.
typedef FutureEither<SuccessType> = Future<Either<Failure, SuccessType>>;

//! SIMPLE FUTURE OF TYPE VOID RETURNING A CUSTOM FUTURE EITHER OF TYPE VOID I.E
//! REGULAR FUTURE THAT RETURNS NOTHING.
typedef FutureVoid = FutureEither<void>;

//! ENUM FOR NOTIFICATION TYPE
enum NotificationType { success, failure, info }

//! AUTHENTICATION RESULT - USED TO MANAGE APP AUTHENTICATION STATE
enum AuthResult { success, failure, noResult }

//! ENUM FOR CONNECTIVITY STATUS
enum ConnectivityStatus { wifi, mobile, online, offline }

//! FOR HAPTIC FEEDBACK
enum AppHapticFeedbackType {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

enum MeetingVenue {
  venue(hallName: "Venue"),
  cit(hallName: "CIT hall"),
  sct(hallName: "SCT hall"),
  wra(hallName: "WRA hall"),
  bucodel1(hallName: "BUCODEL Room 1"),
  bucodel2(hallName: "BUCODEL Room 2"),
  bucodel3(hallName: "BUCODEL Room 3"),
  cafeAuditorium(hallName: "CAFE Auditorium"),
  queenEstherActivityHall(hallName: "Queen Esther A.H");

  final String hallName;

  const MeetingVenue({
    required this.hallName,
  });
}

typedef UserId = String;
