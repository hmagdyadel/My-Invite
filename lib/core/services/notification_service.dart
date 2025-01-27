
import 'package:easy_localization/easy_localization.dart';
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
    icon: '@mipmap/launcher_icon',
  );

  Future<void> init() async {
    // Initialize timezones
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    // Android initialization
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
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

  String _getLocalizedNotificationMessage(String eventTitle, NotificationType type) {
    switch (type) {
      case NotificationType.fiveDays:
        return "event_five_days_reminder".tr(args: [eventTitle]);
      case NotificationType.twoDays:
        return "event_two_days_reminder".tr(args: [eventTitle]);
      case NotificationType.today:
        return "event_today_reminder".tr(args: [eventTitle]);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required DateTime scheduledTime,
    required String title,
    String? payload,
    required NotificationType type,
  }) async {
    try {
      // Convert to timezone-aware datetime
      final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

      // Create notification details
      final NotificationDetails notificationDetails = NotificationDetails(
        android: _androidNotificationDetails,
      );
      final localizedTitle = 'notification_title'.tr();
      final localizedBody = _getLocalizedNotificationMessage(title, type);
      // Schedule the notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        localizedTitle,
        localizedBody,
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
    // final oneDay = eventStart.subtract(const Duration(days: 1));
    //final twoDay = eventStart.subtract(const Duration(days: 2));

    await scheduleNotification(
      id: eventId,
      scheduledTime: eventStart,
      title: eventTitle,
      type: NotificationType.today,
    );
    // final oneDayBefore = eventStart.subtract(const Duration(days: 1));
    // await scheduleNotification(
    //   id: Random().nextInt(100000),
    //   scheduledTime: oneDayBefore,
    //   title: eventTitle,
    //   type: NotificationType.twoDays,
    // );
    //
    // final twoDaysBefore = eventStart.subtract(const Duration(days: 2));
    // await scheduleNotification(
    //   id: Random().nextInt(100000),
    //   scheduledTime: twoDaysBefore,
    //   title: eventTitle,
    //   type: NotificationType.twoDays,
    // );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

enum NotificationType {
  fiveDays,
  twoDays,
  today,
}
