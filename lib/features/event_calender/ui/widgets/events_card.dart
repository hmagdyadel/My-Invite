import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/colors.dart';
import '../../data/models/calender_events.dart';
import '../../logic/event_calender_cubit.dart';

/// Card widget to display individual event details
class EventCard extends StatelessWidget {
  final CalenderEventsResponse event;
  final Color color;

  const EventCard({
    super.key,
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
