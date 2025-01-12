import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/app_utilities.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';
import '../data/repo/login_repo.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginStates.initial());

  LoginResponse? loginResponse;

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

      final response = await _loginRepo.login(LoginRequest(
        username: param.text,
        password: password.text,
        deviceId: await getUniqueDeviceId(),
      ));
      response.when(success: (response) {
        param.clear();
        password.clear();
        AppUtilities().username = response.firstName ?? '';
        emit(LoginStates.success(response));
      }, failure: (error) {
        emit(LoginStates.error(message: error.toString()));
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
