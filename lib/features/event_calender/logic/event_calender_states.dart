import 'package:freezed_annotation/freezed_annotation.dart';
part 'event_calender_states.freezed.dart';

@Freezed()
class EventCalenderStates<T> with _$EventCalenderStates<T>{
  const factory EventCalenderStates.initial()=_Initial;
  const factory EventCalenderStates.loading()=Loading;
  const factory EventCalenderStates.emptyInput()=EmptyInput;
  const factory EventCalenderStates.success(T data)=Success<T>;
  const factory EventCalenderStates.error({required String message})=Error;
}