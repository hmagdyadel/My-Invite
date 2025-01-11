import 'package:freezed_annotation/freezed_annotation.dart';
part 'location_states.freezed.dart';

@Freezed()
class LocationStates<T> with _$LocationStates<T>{
  const factory LocationStates.initial()=_Initial;
  const factory LocationStates.loading()=Loading;
  const factory LocationStates.emptyInput()=EmptyInput;
  const factory LocationStates.success(T data)=Success<T>;
  const factory LocationStates.error({required String message})=Error;
}