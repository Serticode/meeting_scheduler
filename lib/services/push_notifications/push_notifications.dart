import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meeting_scheduler/main.dart';
import 'package:meeting_scheduler/shared/utils/app_extensions.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //!
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  //! GET FCM TOKEN
  static Future<String?> getFCMToken() async =>
      await _firebaseMessaging.getToken();

  //! SUBSCRIBE TO TOPIC
  static Future<void> subscribeToTopic() async =>
      FirebaseMessaging.instance.subscribeToTopic("Notifications");

  //! BACKGROUND
  static Future firebaseBackgroundMessage({
    required RemoteMessage message,
  }) async {
    if (message.notification != null) {
      "Some notification received: ${message.notification}".log();
    }
  }

  //! FOREGROUND
  static StreamSubscription<RemoteMessage> foreGroundMessage() =>
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          String payloadData = jsonEncode(message.data);
          "Got a message in foreground".log();
          if (message.notification != null) {
            await showSimpleNotification(
              title: message.notification!.title!,
              body: message.notification!.body!,
              payload: payloadData,
            );
          }
        },
      );

  //! MESSAGE OPENED
  static StreamSubscription<RemoteMessage> bgNotificationTapped() =>
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          if (message.notification != null) {
            "Background Notification Tapped".log();
            navigatorKey.currentState!
                .pushNamed("/notifications", arguments: message);
          }
        },
      );

  //! LOCAL NOTIFICATIONS
  static Future localNotificationsInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) {});

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  //! LOCAL NOTIFICATION TAP
  static void onNotificationTap(
    NotificationResponse notificationResponse,
  ) async {
    navigatorKey.currentState!
        .pushNamed("/notificationScreen", arguments: notificationResponse);
  }

  //! SHOW NOTIFICATION
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
