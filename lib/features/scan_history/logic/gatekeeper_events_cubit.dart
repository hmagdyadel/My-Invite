import '../data/models/gatekeeper_events_response.dart';
import '../data/repo/gatekeeper_events_repo.dart';
import 'scan_history_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/event_details_response.dart';

class GatekeeperEventsCubit extends Cubit<ScanHistoryStates> {
  final GatekeeperEventsRepo _gatekeeperEventsRepo;

  // For Gatekeeper Events Pagination
  final List<EventsList> _events = [];
  int _currentPageEvents = 1;
  bool _isLoadingEvents = false;
  bool _hasMoreEvents = true;

  // For Event Details Pagination
  final List<EventDetails> _eventDetails = [];
  int _currentPageDetails = 1;
  bool _isLoadingDetails = false;
  bool _hasMoreDetails = true;

  GatekeeperEventsCubit(this._gatekeeperEventsRepo)
      : super(const ScanHistoryStates.initial());

  /// Fetch paginated Gatekeeper Events
  Future<void> getGatekeeperEvents({bool isNextPage = false}) async {
    if (_isLoadingEvents || (!_hasMoreEvents && isNextPage)) return;

    _isLoadingEvents = true;
    if (!isNextPage) {
      _currentPageEvents = 1;
      _events.clear();
      emit(const ScanHistoryStates.loading());
    } else {
      emit(ScanHistoryStates.success(
        GatekeeperEventsResponse(entityList: _events),
        isLoadingMore: true,
      ));
    }

    try {
      final response = await _gatekeeperEventsRepo.getGatekeeperEvents( _currentPageEvents.toString());

      await response.when(
        success: (data) async {
          if (data.entityList != null && data.entityList!.isNotEmpty) {
            if (!isNextPage) _events.clear();
            _events.addAll(data.entityList!);
            _hasMoreEvents =
                data.noOfPages != null && _currentPageEvents < data.noOfPages!;
            _currentPageEvents++;
            emit(ScanHistoryStates.success(
              GatekeeperEventsResponse(entityList: _events),
              isLoadingMore: false,
            ));
          } else {
            _hasMoreEvents = false;
            if (!isNextPage) {
              emit(const ScanHistoryStates.emptyInput());
            } else {
              emit(ScanHistoryStates.success(
                GatekeeperEventsResponse(entityList: _events),
                isLoadingMore: false,
              ));
            }
          }
        },
        failure: (error) {
          if (!isNextPage) {
            emit(ScanHistoryStates.error(message: error.toString()));
          } else {
            emit(ScanHistoryStates.success(
              GatekeeperEventsResponse(entityList: _events),
              isLoadingMore: false,
            ));
          }
        },
      );
    } finally {
      _isLoadingEvents = false;
    }
  }

  /// Fetch paginated Event Details
  Future<void> getEventDetails(String eventId,{bool isNextPage = false}) async {
    if (_isLoadingDetails || (!_hasMoreDetails && isNextPage)) return;

    _isLoadingDetails = true;
    if (!isNextPage) {
      _currentPageDetails = 1;
      _eventDetails.clear();
      emit(const ScanHistoryStates.loading());
    } else {
      emit(ScanHistoryStates.success(
        EventDetailsResponse(eventDetailsList: _eventDetails),
        isLoadingMore: true,
      ));
    }

    try {


      final response = await _gatekeeperEventsRepo.getEventDetails(eventId,_currentPageDetails.toString());

      await response.when(
        success: (data) async {
          if (data.eventDetailsList != null &&
              data.eventDetailsList!.isNotEmpty) {
            if (!isNextPage) _eventDetails.clear();
            _eventDetails.addAll(data.eventDetailsList!);
            _hasMoreDetails =
                data.noOfPages != null && _currentPageDetails < data.noOfPages!;
            _currentPageDetails++;
            emit(ScanHistoryStates.success(
              EventDetailsResponse(eventDetailsList: _eventDetails),
              isLoadingMore: false,
            ));
          } else {
            _hasMoreDetails = false;
            if (!isNextPage) {
              emit(const ScanHistoryStates.emptyInput());
            } else {
              emit(ScanHistoryStates.success(
                EventDetailsResponse(eventDetailsList: _eventDetails),
                isLoadingMore: false,
              ));
            }
          }
        },
        failure: (error) {
          if (!isNextPage) {
            emit(ScanHistoryStates.error(message: error.toString()));
          } else {
            emit(ScanHistoryStates.success(
              EventDetailsResponse(eventDetailsList: _eventDetails),
              isLoadingMore: false,
            ));
          }
        },
      );
    } finally {
      _isLoadingDetails = false;
    }
  }

  // Public properties
  bool get hasMoreEvents => _hasMoreEvents;

  bool get hasMoreDetails => _hasMoreDetails;
}
