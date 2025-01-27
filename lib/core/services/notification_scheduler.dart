import 'package:app/core/helpers/app_utilities.dart';

import '../../features/event_calender/data/models/calender_events.dart';
import '../helpers/time_zone.dart';
import 'notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  Future scheduleNotificationsAtSpecificTime(DateTime dateTime) async {
    try {
      await TimeZone().initializeTimeZone();
      await NotificationService().scheduleEventNotifications(
        eventId: 1,
        eventStart: tz.TZDateTime.from(dateTime, tz.local),
        eventTitle: 'Test Local Notification',
      );
    } catch (e) {
      // debugPrint('Error: $e');
    }
  }

  Future scheduleNotifications({required CalenderEventsResponse event}) async {
    bool notificationsAllowed = AppUtilities().notifications;
    if (notificationsAllowed == false) return;

    try {
      await TimeZone().initializeTimeZone();

      DateTime eventStart = DateTime.parse(event.eventFrom ?? "");

      final tzEventStart = tz.TZDateTime.from(eventStart, tz.local);
      final oneDayBefore = tzEventStart.subtract(const Duration(days: 1));
      final twoDayBefore = tzEventStart.subtract(const Duration(days: 2));

      await NotificationService().scheduleEventNotifications(
        eventId: event.id!,
        eventStart: oneDayBefore,
        eventTitle: event.eventTitle ?? "Event Due",
      );

      await NotificationService().scheduleEventNotifications(
        eventId: int.parse('${event.id}02020'),
        eventStart: twoDayBefore,
        eventTitle: event.eventTitle ?? "Event Due",
      );
    } catch (e) {
      // debugPrint('Error: $e');
    }
  }
}
