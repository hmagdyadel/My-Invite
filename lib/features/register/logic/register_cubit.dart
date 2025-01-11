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
  TextEditingController stateController = TextEditingController();

  Future<void> register({String? country, String? city, bool? isMale}) async {
    emit(const RegisterStates.loading());
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty || country == null || city == null) {
      emit(const RegisterStates.emptyInput());
    }
    // final result = await _registerRepo.register(
    //   email: emailController.text,
    //   password: passwordController.text,
    //   phone: phoneController.text,
    //   firstName: firstNameController.text,
    //   lastName: lastNameController.text,
    //   username: usernameController.text,
    //   state: stateController.text,
    // );
    // emit(result.fold((l) => RegisterStates.error(l), (r) => RegisterStates.success(r)));
  }
}
