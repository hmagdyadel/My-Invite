import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A service class for managing local notifications in the application.
/// This class handles scheduling, canceling, and displaying notifications
/// for events, with support for both Android and iOS platforms.
class NotificationService {
  // Singleton instance of the NotificationService
  static final NotificationService _instance = NotificationService._internal();

  /// Factory constructor to provide access to the singleton instance.
  factory NotificationService() => _instance;

  // Private internal constructor for singleton pattern
  NotificationService._internal();

  /// Instance of [FlutterLocalNotificationsPlugin] used to manage local notifications.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Android-specific notification details for high-importance notifications.
  final AndroidNotificationDetails _androidNotificationDetails = const AndroidNotificationDetails(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel name
    importance: Importance.high, // Importance level
    priority: Priority.high, // Priority level
    playSound: true, // Enable sound
    icon: '@mipmap/launcher_icon', // Notification icon
  );

  /// iOS-specific notification details.
  final DarwinNotificationDetails _iOSNotificationDetails = const DarwinNotificationDetails(
    presentAlert: true, // Show alert
    presentBadge: true, // Show badge
    presentSound: true, // Play sound
  );

  /// Checks and requests notification permissions from the user.
  /// Returns `true` if permissions are granted, otherwise `false`.
  Future<bool> checkAndRequestNotificationPermissions() async {
    if (Platform.isIOS) {
      // Request permissions for iOS
      final settings = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true, // Allow alerts
        badge: true, // Allow badges
        sound: true, // Allow sounds
        critical: true, // Allow critical notifications
        provisional: true, // Allow provisional notifications
      );
      return settings ?? false;
    } else {
      // Request permissions for Android
      final granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      return granted ?? false;
    }
  }

  /// Initializes the notification service.
  /// This includes setting up timezones, initializing notification settings,
  /// and creating notification channels (for Android).
  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();
    // Set the local timezone to 'Africa/Cairo'
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    // Android initialization settings
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization settings
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
    );

    // Combined initialization settings for both platforms
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    // Initialize the local notifications plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create a notification channel for Android (required for Android 8.0+)
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel', // Channel ID
        'High Importance Notifications', // Channel name
        importance: Importance.high, // Importance level
      ),
    );

    // Request notification permissions for iOS
    await checkAndRequestNotificationPermissions();
  }

  /// Returns a localized notification message based on the event title and notification type.
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

  /// Schedules a local notification with the specified details.
  ///
  /// Parameters:
  /// - `id`: Unique ID for the notification.
  /// - `scheduledTime`: The time at which the notification should be displayed.
  /// - `title`: The title of the event.
  /// - `payload`: Optional payload data to be passed with the notification.
  /// - `type`: The type of notification (e.g., today, two days, five days).
  Future<void> scheduleNotification({
    required int id,
    required DateTime scheduledTime,
    required String title,
    String? payload,
    required NotificationType type,
  }) async {
    try {
      // Convert the scheduled time to a timezone-aware datetime
      final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

      // Create notification details for both platforms
      final NotificationDetails notificationDetails = NotificationDetails(
        android: _androidNotificationDetails,
        iOS: _iOSNotificationDetails,
      );

      // Localize the notification title and body
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
      // Log any errors that occur during scheduling
      debugPrint('Notification scheduling error: $e');
    }
  }

  /// Schedules multiple notifications for an event (today, one day before, and two days before).
  ///
  /// Parameters:
  /// - `eventId`: Unique ID of the event.
  /// - `eventStart`: The start time of the event.
  /// - `eventTitle`: The title of the event.
  Future<void> scheduleEventNotifications({
    required int eventId,
    required DateTime eventStart,
    required String eventTitle,
  }) async {
    // Schedule a notification for the event day
    await scheduleNotification(
      id: eventId,
      scheduledTime: eventStart,
      title: eventTitle,
      type: NotificationType.today,
    );

    // Schedule a notification for one day before the event
    final oneDayBefore = eventStart.subtract(const Duration(days: 1));
    await scheduleNotification(
      id: eventId,
      scheduledTime: oneDayBefore,
      title: eventTitle,
      type: NotificationType.twoDays,
    );

    // Schedule a notification for two days before the event
    final twoDaysBefore = eventStart.subtract(const Duration(days: 2));
    await scheduleNotification(
      id: eventId,
      scheduledTime: twoDaysBefore,
      title: eventTitle,
      type: NotificationType.twoDays,
    );
  }

  /// Cancels a specific notification by its ID.
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

/// Enum representing the types of notifications that can be scheduled.
enum NotificationType {
  fiveDays, // Notification for 5 days before the event
  twoDays, // Notification for 2 days before the event
  today, // Notification for the day of the event
}