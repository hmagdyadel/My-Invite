import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../features/events_scan_history/data/models/gatekeeper_events_response.dart';

List<String> months = ['Jan', 'Feb', 'March', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

// Simpler approach without DateFormat parsing
String getDateInWords(String date) {
  if (date.isEmpty) {
    return "";
  }

  try {
    // Split the date string manually to avoid parsing issues
    List<String> parts = date.split('T')[0].split('-');
    if (parts.length != 3) {
      return "";
    }

    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    // Month names
    List<String> monthNames = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    return "${monthNames[month]} $day, $year";
  } catch (e) {
    debugPrint("Manual date format error: $e");
    return "";
  }
}

String getDateAndTime(String date) {
  var inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  DateTime dt = inputDateFormat.parse(date, true).toLocal();

  return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at ${dt.hour}:${dt.minute}';
}

DateTime getDateTimeFromString(String dateString) {
  DateTime date = DateTime.now().toLocal();

  if (dateString.isEmpty) return date;

  var inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  date = inputDateFormat.parse(dateString, true).toLocal();

  return date;
}

bool canCheckinCheckout(EventsList event) {
  bool result = false;

  DateTime start = getDateTimeFromString(event.eventFrom ?? DateTime.now().toString());
  DateTime end = getDateTimeFromString(event.eventTo ?? DateTime.now().toString());

  start = DateTime(start.year, start.month, start.day, 0, 0, 0); // setting start hour, min, sec
  end = DateTime(end.year, end.month, end.day, 23, 59, 59); // setting end hour, min, sec

  int startInt = start.millisecondsSinceEpoch;
  int endInt = end.millisecondsSinceEpoch;
  int now = DateTime.now().millisecondsSinceEpoch;

  if (now >= startInt && now <= endInt) {
    result = true;
  } else {
    result = false;
  }

  return result;
}

String getTimeInAMPM(String date) {
  // Parse the input date string into a DateTime object
  final inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  final DateTime dt = inputDateFormat.parse(date, true).toLocal();

  // Format the time in 12-hour clock with AM/PM
  final formattedTime = DateFormat('h:mm a').format(dt);

  return formattedTime;
}
