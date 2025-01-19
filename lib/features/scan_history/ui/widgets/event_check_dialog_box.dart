import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/widgets/go_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../logic/gatekeeper_events_cubit.dart';
import '../../logic/scan_history_states.dart';
import 'get_gatekeeper_position.dart';

class EventCheckDialogBox extends StatelessWidget {
  final String eventId;

  const EventCheckDialogBox({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GatekeeperEventsCubit, ScanHistoryStates>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => current is ErrorCheck || current is SuccessCheck || current is LoadingCheck,
      builder: (context, current) {
        debugPrint('state ${current is LoadingCheck}');
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
                GoButton(
                  fun: () {
                    context.pop();
                  },
                  titleKey: "check_in".tr(),
                  textColor: Colors.white,
                  btColor: primaryColor,
                  loading: current is LoadingCheck,
                  loaderColor: Colors.white,
                  w: 110,
                ),
                GoButton(
                  fun: () async {
                    final position = await _getUserPosition(context);
                    context.read<GatekeeperEventsCubit>().eventCheckOut(eventId, position);
                  },
                  titleKey: "check_out".tr(),
                  textColor: Colors.white,
                  btColor: Colors.red,
                  loading: current is LoadingCheck,
                  loaderColor: Colors.white,
                  w: 110,
                ),
              ],
            ),
          ],
        );
      },
      listener: (context, current) {
        debugPrint('Listener triggered for errorCheck with error: ');
        current.whenOrNull(errorCheck: (error) {
          debugPrint('Listener triggered for errorCheck with error: $error');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pop();
            context.showErrorToast(error);
          });
        }, successCheck: (response) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pop();
            context.showErrorToast(response.toString());
          });
        });
      },
    );
  }

  Future<Position> _getUserPosition(BuildContext context) async {
    final position = await LocationService.getPosition(context);
    if (position.latitude == -1 || position.longitude == -1) {
      return Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
    }
    return position;
  }
}
