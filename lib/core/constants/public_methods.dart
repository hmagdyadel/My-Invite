import 'package:easy_localization/easy_localization.dart';

import '../../features/scan_history/data/models/gatekeeper_events_response.dart';

List<String> months = ['Jan', 'Feb', 'March', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

String getDateInWords(String date) {
  var inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  DateTime dt = inputDateFormat.parse(date, true).toLocal();

  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
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
