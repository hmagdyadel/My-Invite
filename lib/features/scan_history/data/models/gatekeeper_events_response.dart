import 'package:json_annotation/json_annotation.dart';

part 'gatekeeper_events_response.g.dart';

@JsonSerializable()
class GatekeeperEventsResponse {
  final List<EntityList>? entityList;
  final int? noOfPages;

  GatekeeperEventsResponse({this.entityList, this.noOfPages});

  factory GatekeeperEventsResponse.fromJson(Map<String, dynamic> json) =>
      _$GatekeeperEventsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GatekeeperEventsResponseToJson(this);
}

@JsonSerializable()
class EntityList {
  final String? eventTitle;
  final String? eventFrom;
  final String? eventTo;
  final String? eventVenue;
  final int? id;
  final int? scanned;
  final int? totalAllocated;
  final String? gmapCode;
  final String? eventlocation;
  final String? eventCode;
  final String? contactName;
  final String? contactPhone;
  final String? leaveTime;
  final String? attendanceTime;

  EntityList({
    this.eventTitle,
    this.eventFrom,
    this.eventTo,
    this.eventVenue,
    this.id,
    this.scanned,
    this.totalAllocated,
    this.gmapCode,
    this.eventlocation,
    this.eventCode,
    this.contactName,
    this.contactPhone,
    this.leaveTime,
    this.attendanceTime,
  });

  factory EntityList.fromJson(Map<String, dynamic> json) =>
      _$EntityListFromJson(json);

  Map<String, dynamic> toJson() => _$EntityListToJson(this);
}
