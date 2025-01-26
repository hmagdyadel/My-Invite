
/*
import 'package:app/core/helpers/app_utilities.dart';
import 'package:flutter/material.dart';
import '../../features/event_calender/data/models/calender_events.dart';
import '../helpers/time_zone.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

import 'package:easy_localization/easy_localization.dart';

class NotificationsSchedulerService {
  Future<void> scheduleEventNotifications({
    required CalenderEventsResponse event,
    required BuildContext context
  }) async {
    if (!AppUtilities().notifications) return;

    try {
      await TimeZone().initializeTimeZone();

      DateTime eventStart = DateTime.parse(event.eventFrom ?? "");
      final tzEventStart = tz.TZDateTime.from(eventStart, tz.local);

      final fiveDaysBefore = tzEventStart.subtract(const Duration(days: 5));
      final twoDaysBefore = tzEventStart.subtract(const Duration(days: 2));
      final eventMorning = tz.TZDateTime(
          tz.local,
          tzEventStart.year,
          tzEventStart.month,
          tzEventStart.day,
          13, 18
      );

      await _scheduleLocalizedNotification(
          id: event.id ?? 0,
          dateTime: fiveDaysBefore,
          context: context,
          translationKey: 'event_five_days_reminder',
          titleParams: {'eventTitle': event.eventTitle ?? ''}
      );

      await _scheduleLocalizedNotification(
          id: (event.id ?? 0) + 1000,
          dateTime: twoDaysBefore,
          context: context,
          translationKey: 'event_two_days_reminder',
          titleParams: {'eventTitle': event.eventTitle ?? ''}
      );

      await _scheduleLocalizedNotification(
          id: (event.id ?? 0) + 2000,
          dateTime: eventMorning,
          context: context,
          translationKey: 'event_today_reminder',
          titleParams: {'eventTitle': event.eventTitle ?? ''}
      );
    } catch (e) {
      debugPrint('Notification Scheduling Error: $e');
    }
  }

  Future<void> _scheduleLocalizedNotification({
    required int id,
    required tz.TZDateTime dateTime,
    required BuildContext context,
    required String translationKey,
    Map<String, String>? titleParams,
  }) async {
    String title = tr(
        'notification_title',
        namedArgs: titleParams ?? {},
        context: context
    );

    String body = tr(
        translationKey,
        namedArgs: titleParams ?? {},
        context: context
    );

    await NotificationService().scheduleNotificationAtTime(
        id: id,
        dateTime: dateTime,
        title: title,
        body: body
    );
  }

  Future<void> cancelEventNotifications(int eventId) async {
    await NotificationService().cancelAllNotifications(eventId);
    await NotificationService().cancelAllNotifications(eventId + 1000);
    await NotificationService().cancelAllNotifications(eventId + 2000);
  }
}


 */