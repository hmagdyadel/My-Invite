import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/event_calender_repo.dart';
import 'event_calender_states.dart';

class EventCalenderCubit extends Cubit<EventCalenderStates> {
  final EventCalenderRepo _eventCalenderRepo;

  EventCalenderCubit(this._eventCalenderRepo) : super(const EventCalenderStates.initial());
}
