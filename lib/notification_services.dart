import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  //Initialization flutter local notifications
  void initLocalNotification(RemoteMessage message) async {

    //Android Initialization Settings
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    //Initialization Settings
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    //Flutter Local Notifications Plugin initializationSettings
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payLoad) {


        });
  }//end initLocalNotification

  //Firebase Message listen
  void firebaseMessageInit(){

    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title);
        print(message.notification!.body);
      }

      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {

    //Android Notification Channel Initialized
    AndroidNotificationChannel androidNotificationChannel =
        const AndroidNotificationChannel("id",
            "High Importance Notifications",
            importance: Importance.max);

    //Android Notification Details
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: "Notification Description",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");//end

    //Declare Notification For Device Android or IOS
    NotificationDetails notificationDetails =
        NotificationDetails(
            android: androidNotificationDetails);//end

    //Get Future Notification
    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });//end

  }///end showNotification method

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
