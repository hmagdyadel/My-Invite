import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/notification_scheduler.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/go_button.dart';
import '../../../../core/widgets/normal_text.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/calender_events.dart';
import '../../logic/event_calender_cubit.dart';
import '../../logic/event_calender_states.dart';

class ReservationDialogBox extends StatelessWidget {
  final CalenderEventsResponse event;

  const ReservationDialogBox({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCalenderCubit, EventCalenderStates>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => current is ReservationLoading || current is ReservationSuccess || current is ErrorReservation,
      builder: (context, current) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: Column(
            children: [
              Icon(
                Icons.event_available,
                color: primaryColor,
                size: 60,
              ),
              const SizedBox(
                height: 12,
              ),
              SubTitleText(
                text: "${"reserve".tr()}\n ${event.eventTitle}",
                color: Colors.grey.shade900,
                fontSize: 20,
              ),
            ],
          ),
          content: NormalText(
            text: "confirm_reserve".tr(),
            fontSize: 16,
            color: Colors.grey.shade900,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GoButton(
                  fun: () {
                    //context.pop();
                    context.read<EventCalenderCubit>().reserveEvent(event.id.toString());
                  },
                  titleKey: "yes".tr(),
                  textColor: Colors.white,
                  btColor: primaryColor,
                  w: 110,
                  loaderColor: Colors.white,
                  loading: current is ReservationLoading,
                ),
                GoButton(
                  fun: () {
                    context.pop();
                  },
                  titleKey: "no".tr(),
                  textColor: Colors.white,
                  btColor: Colors.red,
                  w: 110,
                ),
              ],
            ),
          ],
        );
      },
      listener: (context, current) {
        current.whenOrNull(errorReservation: (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pop();
            context.showErrorToast("event_reservation_error_text".tr());
          });
        }, reservationSuccess: (response) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NotificationScheduler().scheduleNotifications(event: event);
            context.pop();
            context.showSuccessToast("event_reserved_text".tr());
          });
        });
      },
    );
  }
}
