import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_states.freezed.dart';

@Freezed()
class LoginStates<T> with _$LoginStates<T>{
  const factory LoginStates.initial()=_Initial;
  const factory LoginStates.loading()=Loading;
  const factory LoginStates.emptyInput()=EmptyInput;
  const factory LoginStates.success(T data)=Success<T>;
  const factory LoginStates.error({required String message})=Error;
}