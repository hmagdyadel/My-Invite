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

  Future<void> fetchLocations() async {
    emit(const RegisterStates.loading());
    final result = await _registerRepo.getLocations();

    result.when(
      success: (locations) => emit(RegisterStates.success(locations)),
      failure: (error) => emit(RegisterStates.error(message: error)),
    );
  }
}
