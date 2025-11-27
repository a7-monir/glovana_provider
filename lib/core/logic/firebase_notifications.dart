import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quick_log/quick_log.dart';




Future<void> firebaseMessagingBackgroundHandler(RemoteMessage data) async {
  GlobalNotification().showNotification(data);
}

class GlobalNotification {
  static String _deviceToken = "";
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  Map<String, dynamic> _not = {};
  final _onMessageStreamController = StreamController.broadcast();

  Future<void> setUpFirebase() async {
    await getFcmToken();
    _firebaseMessaging.setAutoInitEnabled(true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    firebaseCloudMessagingListeners();

    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
      >()
          ?.requestNotificationsPermission();
    } else {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
      >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    var initSetting = const InitializationSettings(
      android: AndroidInitializationSettings('ic_notify'),
      iOS: DarwinInitializationSettings(),
    );
    _notificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  static Future<String> getFcmToken() async {
    try {
      if (_deviceToken != "") {
        return _deviceToken;
      }
      _deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      const Logger("").fine('FCM TOKEN $_deviceToken');
      return _deviceToken;
    } catch (e) {
      const Logger("").error(e.toString());
      return _deviceToken;
    }
  }

  void killNotification() {
    _onMessageStreamController.close();
  }

  Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('onMessage message.data ${message.data}');
      log(
        'onMessage message.notification?.toMap() ${message.notification?.toMap()}',
      );
      log(
        'onMessage message.notification?.android?.channelId ${message.notification?.android?.channelId}',
      );
      _onMessageStreamController.add(message.data);

      _not = message.data;
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(' onMessageOpenedApp message.data ${message.data}');
      log(
        ' onMessageOpenedApp message.notification?.android?.channelId ${message.notification?.android?.channelId}',
      );
      handlePathByRoute(message.data);
    });
  }

  Future<void> showNotification(RemoteMessage data) async {
    var iOSPlatformSpecifics = const DarwinNotificationDetails();
    var androidChannelSpecifics = const AndroidNotificationDetails(
      "id",
      "name",
      channelDescription: "Description",
      importance: Importance.high,
      icon: "@mipmap/ic_launcher_adaptive_for",
      colorized: true,
      color: Colors.white,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iOSPlatformSpecifics,
    );
    if (data.notification != null && Platform.isAndroid) {
      await _notificationsPlugin.show(
        0,
        data.notification!.title,
        data.notification!.body,
        notificationDetails,
      );
    }
  }

  Future<void> handlePathByRoute(Map<String, dynamic> dataMap) async {
    String type = dataMap["key"].toString();
    log(' key: $type');
  }

  onSelectNotification(NotificationResponse? onSelectNotification) async {
    log('payload ${onSelectNotification?.notificationResponseType}');
    handlePathByRoute(_not);
  }
}
