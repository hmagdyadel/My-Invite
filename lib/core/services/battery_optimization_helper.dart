import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class BatteryOptimizationHelper {
  static Future<bool> disableBatteryOptimizations() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        // Only attempt for Android 6.0 and above
        if (androidInfo.version.sdkInt >= 23) {
          const platform = MethodChannel('battery_optimization_channel');
          final result = await platform.invokeMethod('requestIgnoreBatteryOptimizations');
          return result ?? false;
        }
      }
    } catch (e) {
      debugPrint('Battery optimization error: $e');
    }

    return false;
  }
}