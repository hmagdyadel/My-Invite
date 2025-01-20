// Import required packages and local files for the calendar functionality
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

/// A screen widget that displays a calendar with events
/// This widget is stateless as it uses BLoC for state management
class EventCalenderScreen extends StatelessWidget {
  const EventCalenderScreen({super.key});

  /// Generates a unique color for each event based on its index
  /// Uses a predefined list of colors that cycles if there are more events than colors
  Color _getEventColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    // Use modulo to cycle through colors if we have more events than colors
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "events_calendar".tr()),
      // Use BlocBuilder to rebuild UI when state changes
      body: BlocBuilder<EventCalenderCubit, EventCalenderStates>(
        // Initialize the calendar by fetching events when screen loads
        bloc: context.read<EventCalenderCubit>()..getEventsCalendar(),
        builder: (context, state) {
          // Handle different states using when pattern matching
          return state.when(
            initial: () => initialCalender(context),
            loading: () => initialCalender(context),
            emptyInput: () {
              // Show error toast after frame is rendered
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorToast("no_available_events".tr());
              });
              return initialCalender(context);
            },
            success: (events, selectedDay, focusedDay, selectedEvents) =>
                _buildCalendar(context, events, selectedDay, focusedDay, selectedEvents),
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

  /// Creates initial calendar view with empty events
  Widget initialCalender(BuildContext context) {
    return _buildCalendar(
      context,
      [], // Empty events list for initial/loading states
      DateTime.now(),
      DateTime.now(),
      [],
    );
  }

  /// Builds the main calendar widget with events
  /// [events] - List of calendar events to display
  /// [selectedDay] - Currently selected day
  /// [focusedDay] - Day that calendar is focused on
  /// [selectedEvents] - Events for the selected day
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
            // TableCalendar widget configuration
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: focusedDay ?? DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              eventLoader: (day) => _getEventsForDay(events, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (events.isNotEmpty) {
                  // Update selected day in state
                  context.read<EventCalenderCubit>().onDaySelected(selectedDay, focusedDay);
                  // Show bottom sheet with day's events
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
              // Calendar styling configuration
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.rectangle,
                ),
                todayDecoration: BoxDecoration(
                  color: primaryColor.withAlpha(128),
                  shape: BoxShape.rectangle,
                ),
                markersMaxCount: 5,
                canMarkersOverflow: true,
              ),
              // Custom builder for event markers
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();

                  // Build colored lines for events
                  return Positioned(
                    bottom: 1,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        events.length.clamp(0, 5), // Limit to 5 events
                            (index) => Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 0.5),
                            decoration: BoxDecoration(
                              color: _getEventColor(index),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns a list of events for a specific day
  List<CalenderEventsResponse> _getEventsForDay(
      List<CalenderEventsResponse> events,
      DateTime day,
      ) {
    return events.where((event) {
      final eventFrom = DateTime.parse(event.eventFrom ?? "");
      final eventTo = DateTime.parse(event.eventTo ?? "");
      // Check if day falls within event period (including start and end dates)
      return day.isAfter(eventFrom.subtract(const Duration(days: 1))) &&
          day.isBefore(eventTo.add(const Duration(days: 1)));
    }).toList();
  }

  /// Builds the instructions section above the calendar
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

  /// Shows bottom sheet with events for selected day
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

/// Bottom sheet widget to display events for a selected day
class _EventsBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<CalenderEventsResponse> events;

  const _EventsBottomSheet({
    required this.selectedDate,
    required this.events,
  });

  /// Generates consistent colors for events
  Color _getEventColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display selected date header
          Text(
            "Events - ${DateFormat('dd MMMM yyyy').format(selectedDate)}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          // Scrollable list of event cards
          Expanded(
            child: ListView.separated(
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => _EventCard(
                event: events[index],
                color: _getEventColor(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget to display individual event details
class _EventCard extends StatelessWidget {
  final CalenderEventsResponse event;
  final Color color;

  const _EventCard({
    required this.event,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColorOverlay,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: color,
              width: 4,
            ),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showReservationDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event title
                Text(
                  event.eventTitle ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Event venue
                Text(
                  event.eventVenue ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                // Event time range
                _buildEventTimes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the event time display widget
  Widget _buildEventTimes() {
    final eventFrom = DateTime.parse(event.eventFrom ?? "");
    final eventTo = DateTime.parse(event.eventTo ?? "");

    return Row(
      children: [
        Icon(Icons.access_time, color: color, size: 16),
        const SizedBox(width: 8),
        Text(
          "${DateFormat('HH:mm').format(eventFrom)} - ${DateFormat('HH:mm').format(eventTo)}",
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  /// Shows reservation confirmation dialog
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