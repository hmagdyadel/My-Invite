import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_attendance_states.freezed.dart';

@Freezed()
class EventAttendanceStates<T> with _$EventAttendanceStates<T> {
  const factory EventAttendanceStates.initial() = _Initial;

  const factory EventAttendanceStates.loading() = Loading;

  const factory EventAttendanceStates.emptyInput() = EmptyInput;

  const factory EventAttendanceStates.success(T data) = Success<T>;

  const factory EventAttendanceStates.error({required String message}) = Error;
}
