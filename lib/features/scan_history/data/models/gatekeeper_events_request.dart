import 'package:freezed_annotation/freezed_annotation.dart';

part 'gatekeeper_events_request.g.dart';

@JsonSerializable()
class GatekeeperEventsRequest {
  String? pageNo;

  GatekeeperEventsRequest({this.pageNo});

  Map<String, dynamic> toJson() => _$GatekeeperEventsRequestToJson(this);

  factory GatekeeperEventsRequest.fromJson(Map<String, dynamic> json) => _$GatekeeperEventsRequestFromJson(json);
}
