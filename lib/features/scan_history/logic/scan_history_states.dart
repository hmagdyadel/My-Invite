import 'package:freezed_annotation/freezed_annotation.dart';
part 'scan_history_states.freezed.dart';

@Freezed()
class ScanHistoryStates<T> with _$ScanHistoryStates<T>{
  const factory ScanHistoryStates.initial()=_Initial;
  const factory ScanHistoryStates.loading()=Loading;
  const factory ScanHistoryStates.emptyInput()=EmptyInput;
  const factory ScanHistoryStates.success(T data)=Success<T>;
  const factory ScanHistoryStates.error({required String message})=Error;
}