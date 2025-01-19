import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import '../../../../core/widgets/loaders.dart';

class LocationService {
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<Position> getPosition(BuildContext context) async {
    if (!context.mounted) return _defaultPosition();

    // Show loading indicator at the start
    //_showLoadingDialog(context);

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!context.mounted) return _defaultPosition();
        bool enabled = await _requestLocationService();
        if (!enabled) {
          if (!context.mounted) return _defaultPosition();
          return await _handleLocationDisabled(context);
        }
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!context.mounted) return _defaultPosition();
          return await _handlePermissionDenied(context);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!context.mounted) return _defaultPosition();
        return await _handlePermissionDeniedForever(context);
      }

      // Get position with timeout
      final Position position = await Geolocator.getCurrentPosition()
          .timeout(timeoutDuration);

      if (!context.mounted) return position;
      _hideLoadingDialog(context);
      return position;
    } catch (e) {
      if (!context.mounted) return _defaultPosition();
      _hideLoadingDialog(context);
      await _showErrorDialog(
        context,
        'error'.tr(),
        'location_fetch_failed'.tr(),
        'retry'.tr(),
      );
      return _defaultPosition();
    }
  }

  static Future<bool> _requestLocationService() async {
    final loc.Location location = loc.Location();
    try {
      return await location.requestService();
    } catch (e) {
      return false;
    }
  }

  static Future<Position> _handleLocationDisabled(BuildContext context) async {
    _hideLoadingDialog(context);
    await _showErrorDialog(
      context,
      'error'.tr(),
      'location_service_disabled'.tr(),
      'enable_location_service'.tr(),
    );
    return _defaultPosition();
  }

  static Future<Position> _handlePermissionDenied(BuildContext context) async {
    _hideLoadingDialog(context);
    await _showErrorDialog(
      context,
      'error'.tr(),
      'location_permission_denied_short'.tr(),
      'open_settings'.tr(),
    );
    return _defaultPosition();
  }

  static Future<Position> _handlePermissionDeniedForever(
      BuildContext context) async {
    _hideLoadingDialog(context);
    await _showErrorDialog(
      context,
      'error'.tr(),
      'location_permission_denied_long'.tr(),
      'open_settings'.tr(),
    );
    return _defaultPosition();
  }

  // static void _showLoadingDialog(BuildContext context) {
  //   animatedLoaderWithTitle(
  //     context: context,
  //     title: 'getting_location'.tr(),
  //   );
  // }

  static void _hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      popDialog(context);
    }
  }

  static Future<void> _showErrorDialog(BuildContext context,
      String title,
      String message,
      String actionText,) async {
    return dialogWithSingleAction(
      context: context,
      title: title,
      msg: message,
      actionText: actionText,
      onActionTap: () async {
        await Geolocator.openLocationSettings();
        if (context.mounted) {
          context.pop();
        }
      },
    );
  }

  static Position _defaultPosition() {
    return Position(
      longitude: -1,
      latitude: -1,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}