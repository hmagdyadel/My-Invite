import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/calender_events.dart';
import '../data/repo/event_calender_repo.dart';
import 'event_calender_states.dart';

class EventCalenderCubit extends Cubit<EventCalenderStates> {
  final EventCalenderRepo _eventCalenderRepo;

  EventCalenderCubit(this._eventCalenderRepo) : super(const EventCalenderStates.initial());

  void getEventsCalendar() async {
    emit(const EventCalenderStates.loading());
    final response = await _eventCalenderRepo.getEventsCalendar();
    response.when(
      success: (response) {
        List<CalenderEventsResponse> calenderEvents = response;
        if (calenderEvents.isEmpty) {
          emit(const EventCalenderStates.emptyInput());
          return;
        }
        emit(EventCalenderStates.success(response));
      },
      failure: (error) {
        if (error == "location_is_not_set_correctly") {
          emit(EventCalenderStates.error(message: "location_is_not_set_correctly".tr()));
        } else {
          emit(
            EventCalenderStates.error(
              message: error.toString(),
            ),
          );
        }

      },
    );
  }
}
