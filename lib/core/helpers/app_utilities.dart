import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

 // bool? _isLTR;

  bool get isLTR {
    return NavigationService.navigatorKey.currentContext!.locale.languageCode=="en";
  }





  String? _username;
  String get username => _username ?? '';

  set username(String value) {
    _username = value;
    setSavedString("username", value);
  }







  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();
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

  Future<bool> setSavedString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  Future<void> _getSavedData() async {

    _username = await getSavedString("username", '');


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



}
