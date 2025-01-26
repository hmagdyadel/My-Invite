// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // Notification channel details
//   final AndroidNotificationDetails _androidNotificationDetails =
//   const AndroidNotificationDetails(
//     'high_importance_channel',
//     'High Importance Notifications',
//     importance: Importance.high,
//     priority: Priority.high,
//     playSound: true,
//     enableVibration: true,
//   );
//
//   Future<void> init() async {
//     // Initialize timezone database
//     tz.initializeTimeZones();
//
//     // Set a default timezone
//     try {
//       tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
//       debugPrint('Timezone set to: Africa/Cairo');
//     } catch (e) {
//       debugPrint('Failed to set timezone: $e');
//     }
//
//     // Android initialization
//     const AndroidInitializationSettings androidInitializationSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS initialization
//     const DarwinInitializationSettings iOSInitializationSettings =
//     DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     // Combined initialization settings
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iOSInitializationSettings,
//     );
//
//     // Initialize notifications with tap handler
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );
//
//     // Create notification channel for Android
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//
//     await androidImplementation?.createNotificationChannel(
//       const AndroidNotificationChannel(
//         'high_importance_channel',
//         'High Importance Notifications',
//         importance: Importance.high,
//       ),
//     );
//
//     // Request notification permissions
//     await _requestPermissions();
//   }
//
//   Future<void> _requestPermissions() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>();
//
//     await androidImplementation?.requestNotificationsPermission();
//   }
//
//   void _onNotificationTap(NotificationResponse notificationResponse) {
//     debugPrint('Notification Tapped: ${notificationResponse.payload}');
//     // Handle navigation or other actions on notification tap
//   }
//
//   Future<void> scheduleNotification({
//     required int id,
//     required DateTime scheduledTime,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     try {
//       // Ensure the scheduled time is valid
//       final tzDateTime = tz.TZDateTime.from(
//         scheduledTime.isBefore(DateTime.now())
//             ? DateTime.now().add(const Duration(seconds: 5))
//             : scheduledTime,
//         tz.local,
//       );
//
//       // Create notification details
//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: _androidNotificationDetails,
//       );
//
//       // Schedule the notification
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tzDateTime,
//         notificationDetails,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         payload: payload,
//       );
//
//       debugPrint('Notification scheduled: $title at $tzDateTime');
//     } catch (e) {
//       debugPrint('Notification scheduling error: $e');
//     }
//   }
//
//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }
