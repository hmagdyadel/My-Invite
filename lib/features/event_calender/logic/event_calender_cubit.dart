import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/calender_events.dart';
import '../data/repo/event_calender_repo.dart';
import 'event_calender_states.dart';

class EventCalenderCubit extends Cubit<EventCalenderStates> {
  final EventCalenderRepo _eventCalenderRepo;
  List<CalenderEventsResponse> _events = [];

  EventCalenderCubit(this._eventCalenderRepo) : super(const EventCalenderStates.initial());

  void getEventsCalendar() async {
    emit(const EventCalenderStates.loading());
    final response = await _eventCalenderRepo.getEventsCalendar();
    response.when(
      success: (response) {
        _events = response;
        if (_events.isEmpty) {
          emit(const EventCalenderStates.emptyInput());
          return;
        }
        emit(EventCalenderStates.success(
          events: _events,
          selectedDay: DateTime.now(),
          focusedDay: DateTime.now(),
        ));
      },
      failure: (error) => emit(EventCalenderStates.error(message: error.toString())),
    );
  }

  void reserveEvent(String eventId) async {
    emit(const EventCalenderStates.reservationLoading());
    final response = await _eventCalenderRepo.reserveEvent(eventId);
    response.when(
      success: (response) {

        emit(const EventCalenderStates.reservationSuccess("Event reserved successfully"));
      },
      failure: (error) => emit(EventCalenderStates.errorReservation(message: error.toString())),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final events = _getEventsForDay(selectedDay);
    emit(EventCalenderStates.success(
      events: _events,
      selectedDay: selectedDay,
      focusedDay: focusedDay,
      selectedEvents: events,
    ));
  }

  List<CalenderEventsResponse> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      final eventFrom = DateTime.parse(event.eventFrom ?? "");
      final eventTo = DateTime.parse(event.eventTo ?? "");
      return day.isAfter(eventFrom.subtract(const Duration(days: 1))) && day.isBefore(eventTo.add(const Duration(days: 1)));
    }).toList();
  }

  // Future<void> reserveEvent(CalenderEventsResponse event) async {
  //   emit(const EventCalenderStates.reservationLoading());
  //   // Implement your reservation logic here
  //   // Similar to old reserveEvent method
  //   emit(const EventCalenderStates.reservationSuccess("Event reserved successfully"));
  //   getEventsCalendar(); // Refresh events after reservation
  // }
}
