import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quick_log/quick_log.dart';

/// Background handler for FCM (required for onBackgroundMessage)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // In a real app you might need to re-init plugins here,
  // but for now we just show the notification like before.
  await GlobalNotification().showNotification(message);
}

class GlobalNotification {
  static String _deviceToken = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Map<String, dynamic> _not = {};
  final _onMessageStreamController =
  StreamController<Map<String, dynamic>>.broadcast();

  /// Call this from initFirebase() in main.dart
  Future<void> setUpFirebase() async {
    _firebaseMessaging.setAutoInitEnabled(true);

    // iOS/macOS: request permission FIRST and wait for APNs token
    if (Platform.isIOS || Platform.isMacOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
      );

      const Logger('GlobalNotification')
          .i('Notification permission: ${settings.authorizationStatus}');

      // Try a few times to get APNs token (it can be null initially)
      for (var i = 0; i < 3; i++) {
        final apns = await _firebaseMessaging.getAPNSToken();
        if (apns != null) {
          const Logger('GlobalNotification').i('APNS token: $apns');
          break;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    // Foreground presentation options (for iOS; no effect on Android)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM listeners (message, messageOpenedApp)
    await firebaseCloudMessagingListeners();

    // Local notifications permission (Android / iOS)
    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    // Initialize local notifications plugin
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notify.png'),
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // Now that permissions/APNs are handled, get FCM token
    await getFcmToken();

    // Keep FCM token updated
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _deviceToken = token;
      const Logger('GlobalNotification').i('FCM token refreshed: $token');
    });
  }

  /// Public static getter for FCM token
  static Future<String> getFcmToken() async {
    try {
      if (_deviceToken.isNotEmpty) {
        return _deviceToken;
      }

      // On iOS/macOS, avoid calling getToken before APNs is ready
      if (Platform.isIOS || Platform.isMacOS) {
        final apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns == null) {
          const Logger('GlobalNotification')
              .w('APNS token is null, delaying FCM token request');
          return _deviceToken; // still empty for now
        }
      }

      _deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      const Logger('GlobalNotification').i('FCM TOKEN: $_deviceToken');
      return _deviceToken;
    } catch (e, st) {
      const Logger('GlobalNotification')
          .error('getFcmToken error: $e\n$st');
      return _deviceToken;
    }
  }

  void killNotification() {
    _onMessageStreamController.close();
  }

  /// Listen to foreground messages and "tap on notification" events
  Future<void> firebaseCloudMessagingListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('onMessage message.data ${message.data}');
      log(
        'onMessage message.notification?.toMap() '
            '${message.notification?.toMap()}',
      );
      log(
        'onMessage message.notification?.android?.channelId '
            '${message.notification?.android?.channelId}',
      );

      _onMessageStreamController.add(message.data);
      _not = message.data;

      // Show local notification for incoming FCM
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onMessageOpenedApp message.data ${message.data}');
      log(
        'onMessageOpenedApp message.notification?.android?.channelId '
            '${message.notification?.android?.channelId}',
      );
      handlePathByRoute(message.data);
    });
  }

  /// Show local notification using flutter_local_notifications
  Future<void> showNotification(RemoteMessage message) async {
    const iOSPlatformSpecifics = DarwinNotificationDetails();
    const androidChannelSpecifics = AndroidNotificationDetails(
      "id",
      "name",
      channelDescription: "Description",
      importance: Importance.high,
      icon: "ic_notify",
      colorized: true,
      color: Colors.white,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iOSPlatformSpecifics,
    );

    if (message.notification != null && Platform.isAndroid) {
      await _notificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    }
  }

  /// Handle deep linking / navigation based on notification data
  Future<void> handlePathByRoute(Map<String, dynamic> dataMap) async {
    final String type = dataMap["key"]?.toString() ?? '';
    log('key: $type');

    // TODO: use `type` to navigate to specific screens if needed.
    // Example:
    // if (type == 'order') {
    //   navigatorKey.currentState?.pushNamed(OrderScreen.routeName);
    // }
  }

  /// Called when user taps the local notification (foreground/background)
  Future<void> onSelectNotification(NotificationResponse response) async {
    log('payload responseType: ${response.notificationResponseType}');
    await handlePathByRoute(_not);
  }
}
