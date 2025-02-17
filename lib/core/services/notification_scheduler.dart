import 'package:flutter/material.dart';
import '../../features/event_calender/data/models/calender_events.dart';
import '../helpers/time_zone.dart';
import 'new_notification_service.dart';
import 'notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

/// A class responsible for scheduling notifications for calendar events.
/// This class interacts with the [NotificationService] to schedule notifications
/// at specific times or for specific events.
class NotificationScheduler {
  /// Schedules a test notification at a specific date and time.
  ///
  /// Parameters:
  /// - `dateTime`: The date and time at which the notification should be scheduled.
  ///
  /// This method is primarily used for testing notification functionality.
  Future<void> scheduleNotificationsAtSpecificTime(DateTime dateTime) async {
    try {
      // Initialize the timezone database
      await TimeZone().initializeTimeZone();

      // Schedule a test notification using the NotificationService
      await NewNotificationService().scheduleEventNotifications(
        eventId: 160, // Test event ID
        eventStart: tz.TZDateTime.from(dateTime, tz.local), // Convert to timezone-aware datetime
        eventTitle: 'Test Local Notification', // Test event title
      );
    } catch (e) {
      // Log any errors that occur during scheduling
      debugPrint('Error: $e');
    }
  }



  /// Schedules notifications for a calendar event.
  ///
  /// Parameters:
  /// - `event`: The calendar event for which notifications should be scheduled.
  ///
  /// This method schedules a notification for the event's start time.
  /// Notifications are only scheduled if the user has allowed notifications in the app settings.
  Future<void> scheduleNotifications({required CalenderEventsResponse event}) async {
    // // Check if notifications are allowed in the app settings
    // bool notificationsAllowed = AppUtilities().notifications;
    // if (notificationsAllowed == false) return; // Exit if notifications are not allowed

    try {
      // Initialize the timezone database
      await TimeZone().initializeTimeZone();

      // Parse the event start time from the event data
      DateTime eventStart = DateTime.parse(event.eventFrom ?? "");

      // Convert the event start time to a timezone-aware datetime
      final tzEventStart = tz.TZDateTime.from(eventStart, tz.local);

      // Schedule a notification for the event's start time
      await NewNotificationService().scheduleEventNotifications(
        eventId: event.id!, // Event ID
        eventStart: tzEventStart, // Scheduled time
        eventTitle: event.eventTitle ?? "Event Due", // Event title
      );
    } catch (e) {
      // Log any errors that occur during scheduling
      debugPrint('Error: $e');
    }
  }
}