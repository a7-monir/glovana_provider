import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quick_log/quick_log.dart';




Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await GlobalNotification.instance.showNotification(message);
}

class GlobalNotification {
  GlobalNotification._();
  static final GlobalNotification instance = GlobalNotification._();

  static String _deviceToken = "";
  final _fcm = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  final _onMessageCtr = StreamController<Map<String, dynamic>>.broadcast();
  Map<String, dynamic> _lastPayload = {};

  bool _initialized = false;
  bool _initializing = false;
  static bool _permBusy = false;

  Stream<Map<String, dynamic>> get onMessageStream => _onMessageCtr.stream;

  Future<void> setUpFirebase() async {
    if (_initialized || _initializing) return;
    _initializing = true;
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _getFcmToken();

      await _fcm.setAutoInitEnabled(true);
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true,
      );

      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('ic_notify'),
        iOS: DarwinInitializationSettings(),
      );
      await _local.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onSelectNotification,
      );

      if (Platform.isAndroid) {
        await _serializePermission(() async {
          final android = _local.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
          final enabled = await android?.areNotificationsEnabled() ?? true;
          if (!enabled) {
            await android?.requestNotificationsPermission();
          }
        });
      } else if (Platform.isIOS) {
        await _serializePermission(() async {
          await _local
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true);
          await _fcm.requestPermission(alert: true, badge: true, sound: true);
        });
      }

      final android = _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(const AndroidNotificationChannel(
        'id', 'name',
        description: 'Description',
        importance: Importance.high,
      ));

      _attachFcmListeners();
      _initialized = true;
    } catch (e, st) {
      const Logger('GlobalNotification').error('Init failed: $e');
      log('GlobalNotification init error: $e\n$st');
    } finally {
      _initializing = false;
    }
  }

  static Future<String> getFcmToken() async {
    try {
      if (_deviceToken.isNotEmpty) return _deviceToken;
      _deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      const Logger("GlobalNotification").fine('FCM TOKEN $_deviceToken');
      return _deviceToken;
    } catch (e) {
      const Logger("GlobalNotification").error(e.toString());
      return _deviceToken;
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      if (Platform.isAndroid) {
        final android = _local.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        final enabled = await android?.areNotificationsEnabled() ?? true;
        if (!enabled) return;
      }

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'id', 'name',
          channelDescription: 'Description',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher_adaptive_for',
          colorized: true,
          color: Colors.white,
        ),
        iOS: DarwinNotificationDetails(),
      );

      final title = message.notification?.title ?? '';
      final body  = message.notification?.body  ?? '';
      if (title.isNotEmpty || body.isNotEmpty) {
        await _local.show(0, title, body, details);
      }
    } catch (e, st) {
      const Logger("GlobalNotification").error('showNotification error: $e');
      log('showNotification error: $e\n$st');
    }
  }

  void dispose() => _onMessageCtr.close();

  void _attachFcmListeners() {
    FirebaseMessaging.onMessage.listen((m) {
      _lastPayload = m.data;
      _onMessageCtr.add(m.data);
      showNotification(m);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      _handleRoute(m.data);
    });
  }

  Future<void> _serializePermission(Future<void> Function() task) async {
    while (_permBusy) { await Future.delayed(const Duration(milliseconds: 40)); }
    _permBusy = true;
    try { await task(); } finally { _permBusy = false; }
  }

  static Future<String> _getFcmToken() async {
    if (_deviceToken.isNotEmpty) return _deviceToken;
    try {
      _deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      return _deviceToken;
    } catch (_) {
      return _deviceToken;
    }
  }

  Future<void> _onSelectNotification(NotificationResponse r) async {
    _handleRoute(_lastPayload);
  }

  Future<void> _handleRoute(Map<String, dynamic> map) async {
    final type = map['key']?.toString() ?? '';
    log('route key: $type');
    // TODO: navigate based on key
  }
}
