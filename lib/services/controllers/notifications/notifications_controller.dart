import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meeting_scheduler/services/controllers/user_info/user_info_controller.dart';
import 'package:meeting_scheduler/services/database/notifications_database.dart';
import 'package:meeting_scheduler/services/models/model_field_names.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsController, DateTime>(
  NotificationsController.new,
);

class NotificationsController extends AsyncNotifier<DateTime> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //!
  @override
  FutureOr<DateTime> build() => DateTime.now();

  void setDate({required DateTime selectedDay}) {
    state = AsyncValue.data(selectedDay);
  }

  Future<void> setUpPushNotification() async {
    FirebaseFirestore.instance
        .collection(FirebaseCollectionName.notifications)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) async {
      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in snapshot.docs) {
        final userID = ref.read(userIdProvider);

        final NotificationsModel notification = NotificationsModel.fromJSON(
          json: element.data(),
        );

        if (userID! == notification.ownerID) {
          await sendPushNotification();
        }
      }
    });
  }

  Future<void> sendPushNotification() async {
    "Send Push Notification called".log();

    final Map<String, dynamic> payload = {
      "notification": {
        "title": "Document notification",
        "body": "Check your notifications for updates",
      },
    };

    const String serverKey =
        "BMBDfoPLMgoi3SuXioXrZdigifQinGGweVntPCYl8yrM9QLBwkTsFx_aqCn-I76anba1ZU56-24jTh94-owGpmw";
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final Map<String, dynamic> data = {
      "to": "/topics/Notifications",
      "data": payload,
    };

    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      "Notification sent successfully".log();
    } else {
      "Failed to send notification. Status code: ${response.statusCode}".log();
      "Response body: ${response.body}".log();
    }

    _firebaseMessaging;
  }
}

//!
//! NOTIFICATIONS PROVIDER
final AutoDisposeStreamProvider<List<NotificationsModel?>?>
    notificationsProvider =
    StreamProvider.autoDispose<List<NotificationsModel?>?>(
  (ref) {
    final controller = StreamController<List<NotificationsModel?>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.notifications)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      List<NotificationsModel?> notifications = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in snapshot.docs) {
        final NotificationsModel notification = NotificationsModel.fromJSON(
          json: element.data(),
        );

        String? userID = ref.read(userIdProvider);

        if (userID! == notification.ownerID) {
          notifications.add(notification);
        }
      }

      controller.sink.add(notifications);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
