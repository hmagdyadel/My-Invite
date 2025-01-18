import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/dimensions/dimensions.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../../event_attendance/logic/event_attendance_cubit.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';
import 'get_gatekeeper_position.dart';

class EventCheckDialogBox extends StatelessWidget {
  final String eventId;

  const EventCheckDialogBox({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<GatekeeperEventsCubit, ScanHistoryStates>(
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
                const SizedBox(
                  height: 12,
                ),
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
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(primaryColor),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: edge, vertical: edge * 0.7)),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: SubTitleText(
                      text: "check_in".tr(),
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.red),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: edge, vertical: edge * 0.7)),
                    ),
                    onPressed: () async {
                      final position = await _getUserPosition(context);
                      context.read<EventAttendanceCubit>().eventCheckOut(
                            eventId,
                            position,
                          );
                    },
                    child: SubTitleText(
                      text: "check_out".tr(),
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        BlocListener<GatekeeperEventsCubit, ScanHistoryStates>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, current) {
            current.whenOrNull(error: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Pop the dialog by using Navigator
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true)
                    .pop(); // If you have two levels of pop
                context.showErrorToast(error);
              });
            }, success: (response, res) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Pop the dialog by using Navigator
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true)
                    .pop(); // If you have two levels of pop
                context.showErrorToast(response.toString());
              });
            });
          },
          child: SizedBox.shrink(),
        ),
      ],
    );
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
          speedAccuracy: 0);
    }
    return position;
  }
}
