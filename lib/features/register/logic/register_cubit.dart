import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/register_request.dart';
import '../data/repo/register_repo.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(const RegisterStates.initial());

  // Text controllers for the fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // Validate if the given email is in a valid format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validate phone format (only digits)
  bool isValidPhoneFormat(String phoneNumber) {
    final phoneRegex = RegExp(r'^\d+$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Validate full phone number (for final validation)
  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\d{6,}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Validate if the password is at least 6 characters long
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Validate if the first name or last name contains only alphabetic characters
  bool isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z]+$');
    return nameRegex.hasMatch(name);
  }

  // Register function
  Future<void> register({required int cityId, required bool isMale}) async {
    emit(const RegisterStates.loading());

    if (_hasEmptyFields(cityId)) {
      emit(const RegisterStates.emptyInput());
      return;
    }

    if (!_isEmailValid()) return;
    if (!_isPhoneValid()) return;
    if (!_isPasswordValid()) return;
    if (!_arePasswordsMatching()) return;
    if (!_areNamesValid()) return;

    final trimmedUsername = usernameController.text.trim();

    RegisterRequest registerRequestBody = RegisterRequest(
      cityId: cityId,
      email: emailController.text,
      firstName: firstNameController.text,
      gender: isMale ? 'm' : 'f',
      lastName: lastNameController.text,
      password: passwordController.text,
      phoneNumber: phoneController.text,
      userName: trimmedUsername,
      role: "Gatekeeper",
    );

    final result = await _registerRepo.register(registerRequestBody);

    result.when(
      success: (response) {
        emit(RegisterStates.success(response));
      },
      failure: (error) {
        String message = _getErrorMessage(error);
        emit(RegisterStates.error(message: message));
      },
    );
  }

  bool _hasEmptyFields(int cityId) {
    final trimmedUsername = usernameController.text.trim();

    return emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        trimmedUsername.isEmpty ||
        cityId == 0;
  }

  bool _isEmailValid() {
    if (!isValidEmail(emailController.text)) {
      emit(RegisterStates.error(message: "invalid_email".tr()));
      return false;
    }
    return true;
  }

  bool _isPhoneValid() {
    if (!isValidPhoneFormat(phoneController.text)) {
      emit(RegisterStates.error(message: "phone_number_invalid_format".tr()));
      return false;
    }

    if (phoneController.text.length < 6) {
      emit(RegisterStates.error(message: "phone_number_too_short".tr()));
      return false;
    }

    return true;
  }

  bool _isPasswordValid() {
    if (!isValidPassword(passwordController.text)) {
      emit(RegisterStates.error(message: "password_too_short".tr()));
      return false;
    }
    return true;
  }

  bool _arePasswordsMatching() {
    if (passwordController.text != confirmPasswordController.text) {
      emit(RegisterStates.error(message: "passwords_do_not_match".tr()));
      return false;
    }
    return true;
  }

  bool _areNamesValid() {
    if (!isValidName(firstNameController.text)) {
      emit(RegisterStates.error(message: "invalid_first_name".tr()));
      return false;
    }
    if (!isValidName(lastNameController.text)) {
      emit(RegisterStates.error(message: "invalid_last_name".tr()));
      return false;
    }
    return true;
  }

  String _getErrorMessage(String error) {
    switch (error) {
      case "username_exists_error":
        return "username_exists_error".tr();
      default:
        return "register_error".tr();
    }
  }
}