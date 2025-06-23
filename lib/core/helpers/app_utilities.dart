import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/login/data/models/login_response.dart';
import '../services/navigation_service.dart';

class AppUtilities {
  static final AppUtilities _instance = AppUtilities._internal();

  static AppUtilities get instance => _instance;

  factory AppUtilities() {
    return _instance;
  }

  AppUtilities._internal();

  Future<void> initialize() async {
    await _getSavedData();
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();


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

  String? _subscriptionTopic;

  String get subscriptionTopic => _subscriptionTopic ?? '';

  set subscriptionTopic(String value) {
    _subscriptionTopic = value;
    setSavedString("subscriptionTopic", value);
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
    _storage.delete(key: "serverToken");
    _storage.delete(key: "userData");
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
    await _storage.write(key: key, value: value);
    return true; // SecureStorage does not return a success boolean
  }

  Future<bool> setSavedBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());
    return true; // SecureStorage does not return a success boolean
  }


  Future<String> getSavedString(String key, String defaultVal) async {
    try {
      final value = await _storage.read(key: key);
      return value ?? defaultVal;
    } catch (e) {
      debugPrint("Decryption failed for [$key]: $e");
      await _storage.delete(key: key); // Optional: remove corrupted value
      return defaultVal;
    }
  }

  Future<bool> getSavedBool(String key, bool defaultVal) async {
    final value = await _storage.read(key: key);
    return value == 'true' ? true : defaultVal;
  }


  Future<void> _getSavedData() async {
    _username = await getSavedString("username", '');
    _password = await getSavedString("password", '');
    _notifications = await getSavedBool("notifications", false);
    _subscriptionTopic = await getSavedString("subscriptionTopic", '');

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
}
