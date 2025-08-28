<<<<<<< Updated upstream
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velocyverse/networking/apiservices.dart';

class NotificationService {
  static NotificationService? _instance;
  // factory NotificationService() {
  //   _instance ??= NotificationService._internal();
  //   return _instance!;
  // }
  // NotificationService._internal();

  String _fcmToken = '';
  String get fcmToken => _fcmToken;

  // existing fields and methods

  set fcmToken(String? token) {
    _fcmToken = token!;
  }

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔔 Define Notification Channel (Android 8+)
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // unique ID
    'High Importance Notifications', // visible name in settings
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('noti_sound'),
  );

  /// Initialize notification settings
  Future<void> init() async {
    // Request permission for iOS
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    // Setup notification channel for Android
    await _setupNotificationChannel();

    // Handle taps on notifications
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notification tapped: ${details.payload}");
      },
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Background/terminated message click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification clicked: ${message.data}");
    });

    // App opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("App opened from terminated state: ${initialMessage.data}");
    }
  }

  /// Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      final androidDetails = AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: _channel.sound,
        styleInformation: BigTextStyleInformation(
          notification.body ?? '',
          htmlFormatBigText: true,
        ),
        color: Colors.blue, // 🔵 change UI color here
      );

      const iosDetails = DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: message.data.toString(),
      );
    }
  }

  /// Setup Android channel (Oreo+)
  Future<void> _setupNotificationChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  /// Get FCM token
  Future<String?> getFcmToken() async {
    var token = await _messaging.getToken();
    fcmToken = token;
    return token;
  }

  final ApiService _apiService = ApiService();

  /// Send FCM token to backend
  Future<void> sendFCMtoken(String idToken, String device_token) async {
    try {
      print('sending token ....');
      final response = await _apiService.postRequest(
        "/api/firebase-auth/",
        data: {"idToken": idToken, 'd_token': device_token},
      );
      print('response for sending token = ${response.data}');
      if (response.statusCode == 200) {
        debugPrint("✅ Token updated on backend");
      } else {
        debugPrint("❌ Failed to update token");
      }
    } catch (e) {
      debugPrint("⚠️ Error sending token to backend: $e");
    }
  }
}
=======
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:VelocyTaxzz/networking/apiservices.dart';

class NotificationService {
  static NotificationService? _instance;
  // factory NotificationService() {
  //   _instance ??= NotificationService._internal();
  //   return _instance!;
  // }
  // NotificationService._internal();

  String _fcmToken = '';
  String get fcmToken => _fcmToken;

  // existing fields and methods

  set fcmToken(String? token) {
    _fcmToken = token!;
  }

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔔 Define Notification Channel (Android 8+)
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // unique ID
    'High Importance Notifications', // visible name in settings
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  /// Initialize notification settings
  Future<void> init() async {
    // Request permission for iOS
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    // Setup notification channel for Android
    await _setupNotificationChannel();

    // Handle taps on notifications
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notification tapped: ${details.payload}");
      },
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Background/terminated message click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification clicked: ${message.data}");
    });

    // App opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("App opened from terminated state: ${initialMessage.data}");
    }
  }

  /// Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      final androidDetails = AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: _channel.sound,
        styleInformation: BigTextStyleInformation(
          notification.body ?? '',
          htmlFormatBigText: true,
        ),
        color: Colors.blue, // 🔵 change UI color here
      );

      const iosDetails = DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: message.data.toString(),
      );
    }
  }

  /// Setup Android channel (Oreo+)
  Future<void> _setupNotificationChannel() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  /// Get FCM token
  Future<String?> getFcmToken() async {
    var token = await _messaging.getToken();
    fcmToken = token;
    return token;
  }

  final ApiService _apiService = ApiService();

  /// Send FCM token to backend
  Future<void> sendFCMtoken(String idToken, String device_token) async {
    try {
      print('sending token ....');
      final response = await _apiService.postRequest(
        "/api/firebase-auth/",
        data: {"idToken": idToken, 'd_token': device_token},
      );
      print('response for sending token = ${response.data}');
      if (response.statusCode == 200) {
        debugPrint("✅ Token updated on backend");
      } else {
        debugPrint("❌ Failed to update token");
      }
    } catch (e) {
      debugPrint("⚠️ Error sending token to backend: $e");
    }
  }
}
>>>>>>> Stashed changes
