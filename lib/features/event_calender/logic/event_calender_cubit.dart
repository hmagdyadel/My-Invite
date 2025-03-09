import 'package:app/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/notification_scheduler.dart';
import '../data/models/calender_events.dart';
import '../data/repo/event_calender_repo.dart';
import 'event_calender_states.dart';

class EventCalenderCubit extends Cubit<EventCalenderStates> {
  final EventCalenderRepo _eventCalenderRepo;
  List<CalenderEventsResponse> _events = [];

  EventCalenderCubit(this._eventCalenderRepo) : super(const EventCalenderStates.initial());

  CalenderEventsResponse? _calenderEventsResponse;

  CalenderEventsResponse get calenderEventsResponse => _calenderEventsResponse ?? CalenderEventsResponse();

  set calenderEventsResponse(CalenderEventsResponse event) {
    _calenderEventsResponse = event;
  }

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
      success: (response) async {
        await scheduleNotifications();
        emit(const EventCalenderStates.reservationSuccess("Event reserved successfully"));
        // Fetch events again after successful reservation
        getEventsCalendar();
      },
      failure: (error) {
        debugPrint("Error: $error");
        if (error.contains("Can not assign")) {
          emit(EventCalenderStates.errorReservation(message: "already_reserved_an_event".tr()));
        }else {
          emit(EventCalenderStates.errorReservation(message: error.toString()));
        }
       Future.delayed(const Duration(seconds: 3), () {
         getEventsCalendar();
       });
      },
    );
  }

  Future<void> scheduleNotifications() async {
    NavigationService.navigatorKey.currentContext?.showSuccessToast("event_reserved_text".tr());
    if (calenderEventsResponse.id != null) {
      debugPrint("Scheduling notifications for event: ${calenderEventsResponse.eventTitle}");

      await NotificationScheduler().scheduleNotifications(event: calenderEventsResponse);

      debugPrint("Notifications scheduled successfully");
    } else {
      debugPrint("Failed to schedule notification");
    }
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


}
