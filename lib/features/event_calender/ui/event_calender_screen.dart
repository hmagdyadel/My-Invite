import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';
import '../../../core/widgets/subtitle_text.dart';
import '../logic/event_calender_cubit.dart';
import '../logic/event_calender_states.dart';

class EventCalenderScreen extends StatelessWidget {
  const EventCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(
        context,
        "events_calendar".tr(),
      ),
      body: BlocBuilder<EventCalenderCubit, EventCalenderStates>(
        buildWhen: (previous, current) => current != previous,
        bloc: context.read<EventCalenderCubit>()..getEventsCalendar(),
        builder: (context, current) {
          return current.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CupertinoActivityIndicator(color: Colors.white)),
            emptyInput: () => _buildCenteredMessage("no_available_events".tr()),
            success: (success) => const SizedBox.shrink(),
            error: (error) => _buildCenteredMessage(error),
          );
        },
      ),
    );
  }

  Widget _buildCenteredMessage(String message) {
    return Center(
      child: SubTitleText(
        text: message,
        color: Colors.white,
        align: TextAlign.center,
      ),
    );
  }
}
