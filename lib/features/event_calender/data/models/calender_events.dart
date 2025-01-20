import 'package:freezed_annotation/freezed_annotation.dart';

part 'calender_events.g.dart';

@JsonSerializable()
class CalenderEventsResponse {
  int? id;
  String? eventTitle;
  String? eventVenue;
  String? eventFrom;
  String? eventTo;
  String? parentTitle;
  DateTime? startDateTime; // to show events in calendar
  DateTime? endDateTime; // to show events in calendar
  String? color;

  CalenderEventsResponse({
    this.id,
    this.eventTitle,
    this.eventVenue,
    this.eventFrom,
    this.eventTo,
    this.parentTitle,
    this.startDateTime,
    this.endDateTime,
    this.color,
  });

  factory CalenderEventsResponse.fromJson(Map<String, dynamic> json) => _$CalenderEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CalenderEventsResponseToJson(this);
}
