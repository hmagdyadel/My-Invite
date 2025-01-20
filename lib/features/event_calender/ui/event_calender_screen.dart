import 'package:app/core/dimensions/dimensions.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';
import '../data/models/calender_events.dart';
import '../logic/event_calender_cubit.dart';
import '../logic/event_calender_states.dart';

class EventCalenderScreen extends StatelessWidget {
  const EventCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "events_calendar".tr()),
      body: BlocBuilder<EventCalenderCubit, EventCalenderStates>(
        bloc: context.read<EventCalenderCubit>()..getEventsCalendar(),
        builder: (context, state) {
          return state.when(
            initial: () => initialCalender(context),
            loading: () => initialCalender(context),
            emptyInput: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast("no_available_events".tr());
              });
              return initialCalender(context);
            },
            success: (events, selectedDay, focusedDay, selectedEvents) => _buildCalendar(context, events, selectedDay, focusedDay, selectedEvents),
            reservationLoading: () => initialCalender(context),
            reservationSuccess: (message) => initialCalender(context),
            error: (error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast(error);
              });
              return initialCalender(context);
            },
          );
        },
      ),
    );
  }

  Widget initialCalender(BuildContext context) {
    return _buildCalendar(
      context,
      [], // Empty events list for initial/loading states
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    List<CalenderEventsResponse> events,
    DateTime selectedDay,
    DateTime? focusedDay,
    List<CalenderEventsResponse>? selectedEvents,
  ) {
    return Column(
      children: [
        Divider(height: 2, color: navBarBackground),
        _buildInstructions(context),
        Material(
          elevation: 8,
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(edge),
            padding: EdgeInsets.all(edge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(edge * 1.5),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: focusedDay ?? DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              eventLoader: (day) => _getEventsForDay(events, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (events.isNotEmpty) {
                  // Only trigger if we have events
                  context.read<EventCalenderCubit>().onDaySelected(selectedDay, focusedDay);
                  _showDayEventsInModalSheet(
                    context,
                    selectedDay,
                    _getEventsForDay(events, selectedDay),
                  );
                }
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: primaryColor.withAlpha(128),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: primaryColor.withAlpha(128),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<CalenderEventsResponse> _getEventsForDay(
    List<CalenderEventsResponse> events,
    DateTime day,
  ) {
    return events.where((event) {
      final eventFrom = DateTime.parse(event.eventFrom ?? "");
      final eventTo = DateTime.parse(event.eventTo ?? "");
      return day.isAfter(eventFrom.subtract(const Duration(days: 1))) && day.isBefore(eventTo.add(const Duration(days: 1)));
    }).toList();
  }

  Widget _buildInstructions(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: edge * 2, horizontal: edge),
      color: bgColor,
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white, size: 22),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              "event_calendar_instructions".tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDayEventsInModalSheet(
    BuildContext context,
    DateTime selectedDate,
    List<CalenderEventsResponse> events,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) => _EventsBottomSheet(
        selectedDate: selectedDate,
        events: events,
      ),
    );
  }
}

class _EventsBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<CalenderEventsResponse> events;

  const _EventsBottomSheet({
    required this.selectedDate,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            "Events - ${DateFormat('dd MMMM yyyy').format(selectedDate)}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _EventCard(event: events[index]),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CalenderEventsResponse event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColorOverlay,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showReservationDialog(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.eventTitle ?? "", style: const TextStyle(color: Colors.white)),
                  Text(event.eventVenue ?? "", style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildEventTimes(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTimes() {
    // Implement your gradient time display here
    // Similar to the old bottomSheetEventItem
    return Container();
  }

  void _showReservationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Reserve ${event.eventTitle}"),
        content: const Text("Would you like to reserve this event?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Yes"),
            onPressed: () {
              Navigator.pop(context);
              context.read<EventCalenderCubit>().reserveEvent();
            },
          ),
          CupertinoDialogAction(
            child: const Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
