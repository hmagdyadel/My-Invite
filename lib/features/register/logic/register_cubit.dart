import 'package:easy_localization/easy_localization.dart';
import '../data/models/register_request.dart';
import 'register_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/register_repo.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterRepo _registerRepo;

  RegisterCubit(this._registerRepo) : super(const RegisterStates.initial());

  // Text controllers for the fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // Validate if the given email is in a valid format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validate if the given phone number contains only numeric characters
  bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\d+$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Register function
  Future<void> register({required int cityId, required bool isMale}) async {
    emit(const RegisterStates.loading());

    // Check for empty fields first
    if (_hasEmptyFields(cityId)) {
      emit(const RegisterStates.emptyInput());
      return;
    }

    // Validate email and phone number
    if (!_isEmailAndPhoneValid()) {
      return; // Error messages are already emitted
    }

    // Trim spaces from username
    final trimmedUsername = usernameController.text.trim();

    // Construct the register request
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

    // Call the repository to register the user
    final result = await _registerRepo.register(registerRequestBody);

    // Handle the result
    result.when(
      success: (response) {
        emit(RegisterStates.success(response));
      },
      failure: (error) {
        // Map error keys to localized messages
        String message = _getErrorMessage(error);
        emit(RegisterStates.error(message: message));
      },
    );
  }

  // Helper function to check for empty fields
  bool _hasEmptyFields(int cityId) {
    // Trim spaces from username
    final trimmedUsername = usernameController.text.trim();

    return emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        trimmedUsername.isEmpty ||
        cityId == 0;
  }

  // Helper function to validate email and phone
  bool _isEmailAndPhoneValid() {
    if (!isValidEmail(emailController.text)) {
      emit(RegisterStates.error(message: "invalid_email".tr()));
      return false;
    }
    if (!isValidPhoneNumber(phoneController.text)) {
      emit(RegisterStates.error(message: "invalid_phone".tr()));
      return false;
    }
    return true;
  }

  // Helper function to map errors to localized messages
  String _getErrorMessage(String error) {
    switch (error) {
      case "username_exists_error":
        return "username_exists_error".tr();
      default:
        return "register_error".tr();
    }
  }
}
