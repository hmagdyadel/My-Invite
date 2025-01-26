import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/login/data/models/login_response.dart';
import '../services/navigation_service.dart';

class AppUtilities {
  static final AppUtilities _instance = AppUtilities._internal();

  static AppUtilities get instance => _instance;

  factory AppUtilities() {
    return _instance;
  }

  AppUtilities._internal() {
    _getSavedData();
  }

  Future<void> initialize() async {
    await _getSavedData();
  }

  Future<void> importantInitialize() async {
    _serverToken = await getSavedString("serverToken", '');
  }

  String? _serverToken;

  String get serverToken {
    return _serverToken ?? "";
  }

  set serverToken(String token) {
    _serverToken = token;
    setSavedString("serverToken", token);
  }

  bool get isLTR {
    return NavigationService.navigatorKey.currentContext!.locale.languageCode == "en";
  }

  String? _username;

  String get username => _username ?? '';

  set username(String value) {
    _username = value;
    setSavedString("username", value);
  }

  bool? _notifications;

  bool get notifications => _notifications ?? false;

  set notifications(bool value) {
    _notifications = value;
    setSavedBool("notifications", value);
  }

  String? _password;

  String get password => _password ?? '';

  set password(String value) {
    _password = value;
    setSavedString("password", value);
  }

  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("serverToken");
    await prefs.remove("userData");
  }

  Future<bool> setSavedInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  void setLocality(String code) async {
    NavigationService.navigatorKey.currentContext?.setLocale(Locale(code));
  }

  String getDeviceLanguage() {
    return Platform.localeName.split('_')[0];
  }

  set isLTR(bool x) {
    setSavedString("isLTR", x ? 'true' : 'false');
  }

  LoginResponse? _loginData = LoginResponse();

  LoginResponse get loginData {
    return _loginData!;
  }

  set loginData(LoginResponse x) {
    serverToken = "Bearer ${x.token ?? ""}";
    _loginData = x;
    setSavedString("userData", jsonEncode(x.toJson()));
    debugPrint("saved");
  }

  Future<bool> setSavedString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  Future<bool> setSavedBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  Future<void> _getSavedData() async {
    _username = await getSavedString("username", '');
    _password = await getSavedString("password", '');
    _notifications = await getSavedBool("notifications", false);

    String userData = await getSavedString('userData', '');
    if (userData.isNotEmpty) {
      try {
        _loginData = LoginResponse.fromJson(jsonDecode(userData));
      } catch (e) {
        debugPrint("Failed to parse userData: $e");
        _loginData = LoginResponse(); // Default value to avoid null
      }
    } else {
      _loginData = LoginResponse(); // Default value if no data is saved
    }
  }

  Future<int> getSavedInt(String key, int defaultVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getInt(key) ?? defaultVal;
  }

  Future<String> getSavedString(String value, String defaultVal) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    return preferences.getString(value) ?? defaultVal;
  }
  Future<bool> getSavedBool(String value, bool defaultVal) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    return preferences.getBool(value) ?? defaultVal;
  }
}
