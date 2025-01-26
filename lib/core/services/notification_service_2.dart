import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService2 {
  void onNotificationTap(NotificationResponse notificationResponse) {
    debugPrint('Notification Tapped: ${notificationResponse.payload}');
    // Handle navigation or other actions on notification tap
  }

  static final NotificationService2 _instance = NotificationService2._internal();

  factory NotificationService2() {
    return _instance;
  }

  NotificationService2._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    final String currentTimeZone = DateTime.now().timeZoneName;
    debugPrint('Timezone set to: $currentTimeZone');
    tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: NotificationService2().onNotificationTap,
    );
  }

  Future<void> scheduleDailyNotification(DateTime selectedTime) async {
    tz.initializeTimeZones();

    final tz.TZDateTime scheduledTime = tz.TZDateTime.from(selectedTime, tz.local);
    debugPrint('scheduledTime: $scheduledTime tzLocal : ${tz.local}');
    try {
      await _notificationsPlugin.zonedSchedule(
        Random().nextInt(100000),
        "notification title",
        "notification body",
        scheduledTime,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  Future zonedScheduleNotification(String note, DateTime date, occ) async {
    // IMPORTANT!!
    tz.initializeTimeZones();

    int id = Random().nextInt(10000);
    debugPrint(date.toString());
    debugPrint(tz.TZDateTime.parse(tz.local, date.toString()).toString());
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        occ,
        note,
        tz.TZDateTime.parse(tz.local, date.toString()),
        NotificationDetails(
          android: AndroidNotificationDetails(id.toString(), 'your channel name_$id', channelDescription: 'your channel description', playSound: true,),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      return id;
    } catch (e) {
      debugPrint("Error at zonedScheduleNotification----------------------------$e");
      if (e == "Invalid argument (scheduledDate): Must be a date in the future: Instance of 'TZDateTime'") {
        debugPrint("Select future date");
      }
      return -1;
    }
  }

  NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
