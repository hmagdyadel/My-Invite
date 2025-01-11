import '../data/models/register_request.dart';
import 'register_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/register_repo.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(const RegisterStates.initial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  Future<void> register({required int cityId, required bool isMale}) async {
    emit(const RegisterStates.loading());
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        cityId == 0) {
      emit(const RegisterStates.emptyInput());
      return;
    }
    RegisterRequest registerRequestBody = RegisterRequest(
      cityId: cityId,
      email: emailController.text,
      firstName: firstNameController.text,
      gender: isMale ? 'm' : 'f',
      lastName: lastNameController.text,
      password: passwordController.text,
      phoneNumber: phoneController.text,
      userName: usernameController.text,
      role: "Gatekeeper",
    );
    final result = await _registerRepo.register(registerRequestBody);
    result.when(success: (response) {
      emit(RegisterStates.success(response));
    }, failure: (error) {
      emit(RegisterStates.error(message: error));
    });
  }
}
