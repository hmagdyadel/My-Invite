import 'dart:io';

import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/public_methods.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/gatekeeper_events_response.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';
import 'camera_screen.dart';
import 'get_gatekeeper_position.dart';

class EventCheckDialogBox extends StatelessWidget {
  final EventsList event;

  const EventCheckDialogBox({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => current is ErrorCheck || current is SuccessCheck || current is LoadingCheckOut || current is LoadingCheckIn,
      builder: (context, current) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: Column(
            children: [
              const Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 60,
              ),
              const SizedBox(height: 12),
              SubTitleText(
                text: "event_check".tr(),
                color: Colors.grey.shade900,
                fontSize: 20,
              ),
            ],
          ),
          content: NormalText(
            text: "event_check_hint".tr(),
            fontSize: 16,
            color: Colors.grey.shade900,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCheckInButton(context, current),
                _buildCheckOutButton(context, current),
              ],
            ),
          ],
        );
      },
      listener: (context, current) {
        current.whenOrNull(
          errorCheck: (error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pop();
              context.showErrorToast(error);
            });
          },
          successCheck: (response) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pop();
              _handleSuccessResponse(context, response);
            });
          },
        );
      },
    );
  }

  Widget _buildCheckInButton(BuildContext context, ScanHistoryStates current) {
    return GoButton(
      fun: () async {
        if (!_isSameDay(event)) {
          context.pop();
          context.showSuccessToast("can_not_check_in_or_out".tr());
        } else {
          final position = await _getUserPosition(context);
          if (position.latitude == -1 || position.longitude == -1) {
            context.pop();
            return;
          }
          final image = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraScreen()),
          );
          if (image == null) {
            return;
          } else {
            context.showSuccessToast("captureSuccess".tr());
            context.read<GatekeeperEventsCubit>().eventCheckIn(event.id.toString(), position, image);
          }
        }
      },
      titleKey: "check_in".tr(),
      textColor: Colors.white,
      btColor: primaryColor,
      loading: current is LoadingCheckIn,
      loaderColor: Colors.white,
      w: 110,
    );
  }

  Widget _buildCheckOutButton(BuildContext context, ScanHistoryStates current) {
    return GoButton(
      fun: () async {
        if (!_isSameDay(event)) {
          context.pop();
          context.showSuccessToast("can_not_check_in_or_out".tr());
        } else {
          final position = await _getUserPosition(context);
          if (position.latitude == -1 || position.longitude == -1) {
            context.pop();
            return;
          }
          context.read<GatekeeperEventsCubit>().eventCheckOut(event.id.toString(), position);
        }
      },
      titleKey: "check_out".tr(),
      textColor: Colors.white,
      btColor: Colors.red,
      loading: current is LoadingCheckOut,
      loaderColor: Colors.white,
      w: 110,
    );
  }

  bool _isSameDay(EventsList event) {
    return canCheckinCheckout(event);
  }

  Future<Position> _getUserPosition(BuildContext context) async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) {
      return Position(
        longitude: 0,
        latitude: 0,
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
    return position;
  }

  void _handleSuccessResponse(BuildContext context, String response) {
    if (response.contains("In")) {
      if (Platform.isIOS) {
        context.pop();
      }
      context.showSuccessToast("checkInSuccess".tr());
    } else if (response.contains("Out")) {
      context.showSuccessToast("checkOutSuccess".tr());
    } else {
      context.showSuccessToast(response.toString());
    }
  }
}
