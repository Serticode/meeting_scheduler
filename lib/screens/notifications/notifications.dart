import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meeting_scheduler/screens/widgets/no_notifications.dart';
import 'package:meeting_scheduler/shared/app_elements/app_colours.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColours.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColours.greyBlack),
        title: "Notifications".txt(
          fontSize: 21.0,
          color: AppColours.greyBlack,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),

      //!
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NoNotifications().alignCenter(),
        ],
      ).generalPadding,
    );
  }
}
