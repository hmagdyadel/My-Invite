import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../data/repo/event_attendance_repo.dart';
import 'event_attendance_states.dart';

class EventAttendanceCubit extends Cubit<EventAttendanceStates> {
  final EventAttendanceRepo _eventAttendanceRepo;

  EventAttendanceCubit(this._eventAttendanceRepo)
      : super(const EventAttendanceStates.initial());

  void eventCheckOut(String eventId, Position position) async {
    emit(const EventAttendanceStates.loading());
    final response =
        await _eventAttendanceRepo.eventCheckOut(eventId, position);
    response.when(success: (response) {
      emit(EventAttendanceStates.success(response));
    }, failure: (error) {
      emit(
        EventAttendanceStates.error(
          message: error.toString(),
        ),
      );
    });
  }
}
