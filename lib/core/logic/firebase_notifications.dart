import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:glovana_provider/views/home_nav/view.dart';
import 'package:glovana_provider/views/notifications/view.dart';
import 'package:glovana_provider/views/wallet/view.dart';

import 'app_logger.dart';
import 'firebase_init.dart';
import 'helper_methods.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await ensureFirebaseInitialized();
  await GlobalNotification().showNotification(
    message,
    fromBackgroundHandler: true,
  );
}

class GlobalNotification {
  GlobalNotification._();

  static final GlobalNotification _instance = GlobalNotification._();
  factory GlobalNotification() => _instance;

  static String _deviceToken = "";
  static const AndroidNotificationChannel _androidNotificationChannel =
      AndroidNotificationChannel(
        'glovana_general_notifications',
        'General Notifications',
        description: 'Important updates about appointments and account changes',
        importance: Importance.max,
      );
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _localNotificationsInitialized = false;
  static Map<String, dynamic> _lastNotificationData = {};
  static Map<String, dynamic>? _pendingNavigationData;
  static bool _pendingNavigationResetStack = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _onMessageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Future<void> setUpFirebase() async {
    await ensureFirebaseInitialized();
    _firebaseMessaging.setAutoInitEnabled(true);

    if (Platform.isIOS || Platform.isMacOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        sound: true,
      );

      AppLogger.info(
        'Notification permission updated',
        tag: 'PUSH',
        data: {'status': settings.authorizationStatus.name},
      );

      for (var i = 0; i < 3; i++) {
        final apns = await _firebaseMessaging.getAPNSToken();
        if (apns != null) {
          AppLogger.debug('APNS token received', tag: 'PUSH');
          break;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _ensureLocalNotificationsInitialized();
    await firebaseCloudMessagingListeners();
    await getFcmToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _deviceToken = token;
      AppLogger.info('FCM token refreshed', tag: 'PUSH');
    });
  }

  static Future<String> getFcmToken() async {
    try {
      await ensureFirebaseInitialized();

      if (_deviceToken.isNotEmpty) {
        return _deviceToken;
      }

      if (Platform.isIOS || Platform.isMacOS) {
        final apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns == null) {
          AppLogger.warning(
            'APNS token not ready, delaying FCM token request',
            tag: 'PUSH',
          );
          return _deviceToken;
        }
      }

      _deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      AppLogger.info('FCM token available', tag: 'PUSH');
      return _deviceToken;
    } catch (e, st) {
      AppLogger.error(
        'Failed to get FCM token',
        tag: 'PUSH',
        error: e,
        stackTrace: st,
      );
      return _deviceToken;
    }
  }

  void killNotification() {
    _onMessageStreamController.close();
  }

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized) {
      return;
    }

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (Platform.isAndroid) {
      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.createNotificationChannel(
        _androidNotificationChannel,
      );
    } else {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notify'),
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) =>
          onSelectNotification(response),
    );

    final launchDetails = await _notificationsPlugin
        .getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      await _handleNotificationPayload(
        launchDetails?.notificationResponse?.payload,
        resetStack: true,
      );
    }

    _localNotificationsInitialized = true;
  }

  Future<void> firebaseCloudMessagingListeners() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.info(
        'Push launched app from terminated state',
        tag: 'PUSH',
        data: {'data': initialMessage.data},
      );
      await handlePathByRoute(initialMessage.data, resetStack: true);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.info(
        'Foreground push received',
        tag: 'PUSH',
        data: {
          'data': message.data,
          'notification': message.notification?.toMap(),
        },
      );

      _onMessageStreamController.add(message.data);
      _lastNotificationData = _normalizeData(message.data);
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.info(
        'Push notification opened',
        tag: 'PUSH',
        data: {
          'data': message.data,
          'channelId': message.notification?.android?.channelId,
        },
      );
      handlePathByRoute(message.data);
    });
  }

  Future<void> showNotification(
    RemoteMessage message, {
    bool fromBackgroundHandler = false,
  }) async {
    await _ensureLocalNotificationsInitialized();

    const iOSPlatformSpecifics = DarwinNotificationDetails();
    const androidChannelSpecifics = AndroidNotificationDetails(
      'glovana_general_notifications',
      'General Notifications',
      channelDescription:
          'Important updates about appointments and account changes',
      importance: Importance.max,
      icon: 'ic_notify',
      colorized: true,
      color: Colors.white,
      priority: Priority.max,
    );
    const notificationDetails = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iOSPlatformSpecifics,
    );

    final normalizedData = _normalizeData(message.data);
    if (normalizedData.isNotEmpty) {
      _lastNotificationData = normalizedData;
    }

    final title =
        message.notification?.title ?? message.data['title']?.toString();
    final body = message.notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) {
      return;
    }

    final shouldShowLocalNotification = fromBackgroundHandler
        ? message.notification == null
        : Platform.isAndroid ||
              (Platform.isIOS && message.notification == null);

    if (shouldShowLocalNotification) {
      await _notificationsPlugin.show(
        _nextNotificationId(),
        title,
        body,
        notificationDetails,
        payload: normalizedData.isEmpty ? null : jsonEncode(normalizedData),
      );
    }
  }

  Future<void> handlePathByRoute(
    Map<String, dynamic> dataMap, {
    bool resetStack = false,
  }) async {
    final normalizedData = _normalizeData(dataMap);
    if (normalizedData.isEmpty) {
      return;
    }

    _lastNotificationData = normalizedData;
    AppLogger.debug(
      'Handling push route',
      tag: 'PUSH',
      data: {'payload': normalizedData},
    );

    if (navigatorKey.currentState == null) {
      _pendingNavigationData = normalizedData;
      _pendingNavigationResetStack = resetStack;
      return;
    }

    await _navigateByKey(normalizedData, resetStack: resetStack);
  }

  Future<void> onSelectNotification(NotificationResponse response) async {
    AppLogger.debug(
      'Local notification selected',
      tag: 'PUSH',
      data: {
        'responseType': response.notificationResponseType.name,
        'payload': response.payload,
      },
    );
    await _handleNotificationPayload(response.payload);
  }

  Future<void> flushPendingNavigation() async {
    if (_pendingNavigationData == null || navigatorKey.currentState == null) {
      return;
    }

    final pendingData = Map<String, dynamic>.from(_pendingNavigationData!);
    final resetStack = _pendingNavigationResetStack;
    _pendingNavigationData = null;
    _pendingNavigationResetStack = false;

    await _navigateByKey(pendingData, resetStack: resetStack);
  }

  Future<void> _handleNotificationPayload(
    String? payload, {
    bool resetStack = false,
  }) async {
    final payloadData = _decodePayload(payload);
    if (payloadData.isNotEmpty) {
      await handlePathByRoute(payloadData, resetStack: resetStack);
      return;
    }

    if (_lastNotificationData.isNotEmpty) {
      await handlePathByRoute(_lastNotificationData, resetStack: resetStack);
    }
  }

  Future<void> _navigateByKey(
    Map<String, dynamic> dataMap, {
    required bool resetStack,
  }) async {
    final type = (dataMap['key'] ?? dataMap['screen'] ?? 'notification')
        .toString()
        .trim()
        .toLowerCase();
    final keepHistory = !resetStack;

    switch (type) {
      case 'appointment':
        await navigateTo(
          const HomeNavView(pageIndex: 0),
          keepHistory: keepHistory,
        );
        return;
      case 'wallet':
        await navigateTo(const WalletView(), keepHistory: keepHistory);
        return;
      case 'account':
        await navigateTo(
          const HomeNavView(pageIndex: 2),
          keepHistory: keepHistory,
        );
        return;
      case 'notification':
      default:
        await navigateTo(const NotificationsView(), keepHistory: keepHistory);
    }
  }

  Map<String, dynamic> _normalizeData(Map<String, dynamic> dataMap) {
    final normalizedData = <String, dynamic>{};
    dataMap.forEach((key, value) {
      if (value != null) {
        normalizedData[key.toString()] = value;
      }
    });
    return normalizedData;
  }

  Map<String, dynamic> _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Failed to decode notification payload',
        tag: 'PUSH',
        data: {
          'payload': payload,
          'error': AppLogger.summarizeError(error),
          'stackTrace': stackTrace.toString(),
        },
      );
    }

    return {};
  }

  int _nextNotificationId() {
    return DateTime.now().microsecondsSinceEpoch.remainder(2147483647);
  }
}
