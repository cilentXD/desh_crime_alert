import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(); // Using DarwinInitializationSettings for iOS
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);
  }

  static Future<void> showEmergencyNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'emergency_channel',
      'Emergency Alerts',
      channelDescription: 'Channel for important emergency alerts.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
