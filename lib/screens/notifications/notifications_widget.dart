import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meeting_scheduler/router/router.dart';
import 'package:meeting_scheduler/router/routes.dart';
import 'package:meeting_scheduler/services/controllers/meetings_controllers/meetings_controller.dart';
import 'package:meeting_scheduler/services/database/notifications_database.dart';
import 'package:meeting_scheduler/services/models/meeting/scheduled_meeting_model.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/app_elements/app_images.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/type_def.dart';

class NotificationsWidget extends ConsumerWidget {
  final NotificationsType notificationsType;
  final NotificationsModel notification;
  const NotificationsWidget({
    super.key,
    required this.notificationsType,
    required this.notification,
  });

  static const green = Color(0xFF00CC99);
  static const grey = Color(0xFFBDBDD7);
  static const red = Color(0xFFBD0000);

  static List icons = [
    AppImages.done,
    AppImages.info,
    AppImages.cancel,
  ];

  static List titles = [
    "Success",
    "Info",
    "Error",
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colour = switch (notificationsType) {
      NotificationsType.created => green,
      NotificationsType.info => grey,
      NotificationsType.deleted => red,
    };

    final meetings = ref.read(meetingsProvider);

    return Container(
      height: 90,
      color: switch (notificationsType) {
        NotificationsType.created => green.withOpacity(0.1),
        NotificationsType.info => grey.withOpacity(0.2),
        NotificationsType.deleted => red.withOpacity(0.1),
      },

      //! CHILD
      child: Row(
        children: [
          Container(height: 85, width: 4, color: colour),

          //! SPACER
          12.0.sizedBoxWidth,

          //!
          CircleAvatar(
            radius: 24,
            backgroundColor: colour,
            child: switch (notificationsType) {
              NotificationsType.created => SvgPicture.asset(icons[0]),
              NotificationsType.info => SvgPicture.asset(icons[1]),
              NotificationsType.deleted => SvgPicture.asset(icons[2])
            },
          ),

          10.0.sizedBoxWidth,

          //!
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! TITLE
              switch (notificationsType) {
                NotificationsType.created => titles[0]
                    .toString()
                    .txt(fontSize: 14, fontWeight: FontWeight.w500),
                NotificationsType.info => titles[1]
                    .toString()
                    .txt(fontSize: 14, fontWeight: FontWeight.w500),
                NotificationsType.deleted => titles[2]
                    .toString()
                    .txt(fontSize: 14, fontWeight: FontWeight.w500),
              },

              //!
              6.0.sizedBoxHeight,

              meetings.when(
                data: (listOfMeetings) {
                  ScheduledMeetingModel? meeting;

                  for (var element in listOfMeetings) {
                    if (element != null &&
                        element.meetingID == notification.meetingID) {
                      meeting = element;
                    }
                  }

                  return RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: notification.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: AppColours.black50,
                          )),
                      TextSpan(
                        text:
                            (notificationsType == NotificationsType.deleted) ||
                                    meeting == null ||
                                    meeting.isEmpty
                                ? ""
                                : " For more, view details.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: colour,
                          fontSize: 10,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = notificationsType ==
                                  NotificationsType.deleted
                              ? () {}
                              : () {
                                  if (meeting != null || meeting!.isNotEmpty) {
                                    AppNavigator.instance.navigateToPage(
                                      thePageRouteName: AppRoutes.viewMeeting,
                                      context: context,
                                      arguments: {"meeting": meeting},
                                    );
                                  }
                                },
                      ),
                    ]),
                  ).withHapticFeedback(
                    onTap: null,
                    feedbackType: AppHapticFeedbackType.mediumImpact,
                  );
                },

                //!
                error: (error, trace) => "$error".txt16().alignCenter(),
                loading: () => const CircularProgressIndicator().alignCenter(),
              ),

              /* RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: notification.message,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: AppColours.black50,
                      )),
                  TextSpan(
                    text: notificationsType == NotificationsType.deleted
                        ? ""
                        : " For more, view details.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colour,
                      fontSize: 10,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = notificationsType == NotificationsType.deleted
                          ? () {}
                          : () {
                              meetings.when(
                                data: (listOfMeetings) {
                                  ScheduledMeetingModel? meeting;

                                  for (var element in listOfMeetings) {
                                    if (element != null &&
                                        element.meetingID ==
                                            notification.meetingID) {
                                      meeting = element;
                                    }
                                  }

                                  if (meeting != null || meeting!.isNotEmpty) {
                                    AppNavigator.instance.navigateToPage(
                                      thePageRouteName: AppRoutes.viewMeeting,
                                      context: context,
                                      arguments: {"meeting": meeting},
                                    );
                                  }
                                },

                                //!
                                error: (error, trace) =>
                                    "$error".txt16().alignCenter(),
                                loading: () => const CircularProgressIndicator()
                                    .alignCenter(),
                              );
                            },
                  ),
                ]),
              ).withHapticFeedback(
                onTap: null,
                feedbackType: AppHapticFeedbackType.mediumImpact,
              ), */
            ],
          ),
        ],
      ),
    );
  }
}
