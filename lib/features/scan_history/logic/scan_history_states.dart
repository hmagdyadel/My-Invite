import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/gatekeeper_events_response.dart';
part 'scan_history_states.freezed.dart';

@Freezed()
class ScanHistoryStates<T> with _$ScanHistoryStates<T>{
  const factory ScanHistoryStates.initial()=_Initial;
  const factory ScanHistoryStates.loading()=_Loading;
  const factory ScanHistoryStates.emptyInput()=_EmptyInput;
  const factory ScanHistoryStates.success(
      GatekeeperEventsResponse response, {
        @Default(false) bool isLoadingMore,
      }) = _Success;
  const factory ScanHistoryStates.error({required String message})=_Error;
}