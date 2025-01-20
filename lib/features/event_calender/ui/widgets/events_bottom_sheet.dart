import 'package:easy_localization/easy_localization.dart';

import '../../data/models/calender_events.dart';
import 'package:flutter/material.dart';

import 'events_card.dart';
import 'events_color.dart';

/// Bottom sheet widget to display events for a selected day
class EventsBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<CalenderEventsResponse> events;

  const EventsBottomSheet({
    super.key,
    required this.selectedDate,
    required this.events,
  });

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
              itemBuilder: (context, index) => EventCard(
                event: events[index],
                color: getEventColor(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
