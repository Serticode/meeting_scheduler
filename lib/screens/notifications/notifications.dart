import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/notifications/notifications_widget.dart';
import 'package:meeting_scheduler/screens/widgets/no_notifications.dart';
import 'package:meeting_scheduler/services/controllers/notifications/notifications_controller.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:meeting_scheduler/shared/utils/utils.dart';
import 'package:stacked_listview/stacked_listview.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({
    super.key,
    this.notificationResponse,
  });
  final NotificationResponse? notificationResponse;

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late Map? payload = {};

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColours.greyBlack, size: 18),
        title: "Notifications".txt(
          fontSize: 16.0,
          color: AppColours.greyBlack,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),

      //!
      body: notifications.when(
        data: (notificationList) {
          return notificationList == null || notificationList.isEmpty
              ? const NoNotifications().alignCenter().generalPadding
              : StackedListView(
                  padding: EdgeInsets.zero,
                  itemCount: notificationList.length,
                  reverse: true,
                  itemExtent: 100,
                  heightFactor: 0.98,
                  fadeOutFrom: 0.01,
                  physics: const BouncingScrollPhysics(),
                  builder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: NotificationsWidget(
                        notificationsType: AppUtils.getNotificationType(
                          notificationsTypeName:
                              notificationList.elementAt(index)!.type,
                        ),
                        notification: notificationList.elementAt(index)!,
                      ),
                    );
                  },
                ).generalPadding;
        },

        //!
        error: (error, trace) => "$error".txt16(),
        loading: () => const CircularProgressIndicator().alignCenter(),
      ),
    );
  }
}
