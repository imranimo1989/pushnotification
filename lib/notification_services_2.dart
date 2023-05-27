import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServicesBeta {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;



  void requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        carPlay: true,
        sound: true,
        announcement: true,
        criticalAlert: true,
        provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User permission granted");
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User provisional permission granted ");
    } else {
      AppSettings.openNotificationSettings();
    }
  }

  Future<String> getDeviceToken() async {
    final token = await firebaseMessaging.getToken();
    return token!;
  }

  void onRefreshDeviceToken() async {
    firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh device token $event");
    });

  }
}
