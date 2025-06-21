import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          requestCriticalPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _createNotificationChannel();
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _createNotificationChannel() async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'emergency_channel',
      'Emergency Alerts',
      description: 'Channel for emergency alert notifications',
      importance: Importance.high,
      sound: const RawResourceAndroidNotificationSound('emergency_siren'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
      ledColor: Colors.red,
      showBadge: true,
    );

    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel);
    }
  }

  Future<void> showEmergencyNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {

     



      final androidDetails = AndroidNotificationDetails(
        'emergency_channel',
        'Emergency Alerts',
        channelDescription: 'Channel for emergency alert notifications',
        importance: Importance.high,
        priority: Priority.high,
        sound: const RawResourceAndroidNotificationSound('emergency_siren'),
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
        enableLights: true,
        ledColor: Colors.red,
        showWhen: true,
        ticker: 'Emergency Alert',
        timeoutAfter: 10000,
        fullScreenIntent: true,
        visibility: NotificationVisibility.public,
      );

      const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'emergency_siren.wav',
      );

      final NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _notifications.show(0, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    try {
      // Handle notification tap
      if (response.payload != null) {
        debugPrint('Notification tapped with payload: ${response.payload}');
      } else {
        debugPrint('Notification tapped');
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }
}


