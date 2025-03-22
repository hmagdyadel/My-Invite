import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/app_utilities.dart';
import '../data/models/login_request.dart';
import '../data/repo/login_repo.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginStates.initial());

  //LoginResponse? loginResponse;

  final TextEditingController param = TextEditingController();
  final TextEditingController password = TextEditingController();
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  void login() async {
    try {
      emit(const LoginStates.loading());

      if (param.text.isEmpty || password.text.isEmpty) {
        emit(const LoginStates.emptyInput());
        return;
      }
      // Trim spaces from username
      final trimmedUsername = param.text.trim();
      final response = await _loginRepo.login(LoginRequest(
        username: trimmedUsername,
        password: password.text,
        deviceId: await getUniqueDeviceId(),
      ));
      response.when(success: (response) {
        AppUtilities().username = trimmedUsername;
        AppUtilities().password = password.text;
        param.clear();
        password.clear();
        AppUtilities().loginData = response;
        emit(LoginStates.success(response));
      }, failure: (error) {
        if (error == 'unauthorized_error') {
          emit(LoginStates.error(message: 'unauthorized_error'.tr()));
        } else if (error == 'unexpected_error') {
          emit(LoginStates.error(message: 'unexpected_error'.tr()));
        } else if (error == "account_not_approved") {
          emit(LoginStates.error(message: "account_not_approved".tr()));
        } else {
          emit(LoginStates.error(message: "login_error".tr()));
        }
      });
    } catch (e) {
      emit(
        LoginStates.error(
          message: e.toString(),
        ),
      );
    }
  }

  Future<String> getUniqueDeviceId() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor!;
    }
  }
}
