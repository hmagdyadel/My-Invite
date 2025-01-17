import 'package:easy_localization/easy_localization.dart';

List<String> months = [
  'Jan',
  'Feb',
  'March',
  'Apr',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];
String getDateInWords(String date){

  var inputDateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
  DateTime dt = inputDateFormat.parse(date,true).toLocal();

  return '${months[dt.month-1]} ${dt.day}, ${dt.year}';

}