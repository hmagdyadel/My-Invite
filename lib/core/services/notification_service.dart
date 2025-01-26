import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Notification channel details
  final AndroidNotificationDetails _androidNotificationDetails = const AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  Future<void> init() async {
    // Initialize timezones
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    // Android initialization
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    // Initialize local notifications
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create notification channel for Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime scheduledTime,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      // Ensure the scheduled time is in the future
      final now = DateTime.now();
      final futureTime = scheduledTime.isBefore(now)
          ? now.add(const Duration(minutes: 1))
          : scheduledTime;

      // Convert to timezone-aware datetime
      final tzDateTime = tz.TZDateTime.from(futureTime, tz.local);

      // Create notification details
      final NotificationDetails notificationDetails = NotificationDetails(
        android: _androidNotificationDetails,
      );

      // Schedule the notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
    }
  }

  Future<void> scheduleEventNotifications({
    required int eventId,
    required DateTime eventStart,
    required String eventTitle,
  }) async {
    // Schedule notifications 48 and 24 hours before event
    final oneDay = eventStart.subtract(const Duration(days: 1));
    final twoDay = eventStart.subtract(const Duration(days: 2));

    await scheduleNotification(
      id: eventId,
      scheduledTime: oneDay,
      title: eventTitle,
      body: 'Event $eventTitle starts in 24 hours',
    );

    await scheduleNotification(
      id: int.parse('${eventId}02020'),
      scheduledTime: twoDay,
      title: eventTitle,
      body: 'Event $eventTitle starts in 48 hours',
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
