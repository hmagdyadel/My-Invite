import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/client_event_details_response.dart';
import '../data/models/client_event_response.dart';
import '../data/repo/client_events_repo.dart';
import 'client_events_states.dart';

class ClientEventsCubit extends Cubit<ClientEventsStates> {
  final ClientEventsRepo _clientEventsRepo;

  ClientEventsCubit(this._clientEventsRepo) : super(const ClientEventsStates.initial());

  // For Gatekeeper Events Pagination
  final List<ClientEventDetails> _events = [];
  int _currentPageEvents = 0; // Changed to start from 0 like old code
  int _totalPagesEvents = 1;
  bool _isLoadingEvents = false;

  /// Check if more events pages are available
  bool get hasMoreEvents => _currentPageEvents < _totalPagesEvents - 1;

  /// Reset events pagination
  void resetEventsPage() {
    _currentPageEvents = 0;
    _events.clear();
    _totalPagesEvents = 1;
  }

  /// Fetch paginated Client Events
  Future<void> getClientEvents({bool isNextPage = false}) async {
    // Don't proceed if already loading or trying to load next page when no more pages
    if (_isLoadingEvents || (!hasMoreEvents && isNextPage)) return;

    try {
      _isLoadingEvents = true;

      if (!isNextPage) {
        resetEventsPage();
        emit(const ClientEventsStates.loading());
      } else {
        _currentPageEvents++;
        emit(ClientEventsStates.success(
          ClientEventResponse(eventDetailsList: _events),
          isLoadingMore: true,
        ));
      }

      final response = await _clientEventsRepo.getClientEvents(
        (_currentPageEvents + 1).toString(), // Adding 1 because API expects 1-based index
      );

      await response.when(
        success: (data) async {
          if (data.eventDetailsList != null && data.eventDetailsList!.isNotEmpty) {
            if (_currentPageEvents == 0) {
              _events.clear();
              _totalPagesEvents = data.noOfPages ?? 1;
            }

            _events.addAll(data.eventDetailsList!);

            emit(ClientEventsStates.success(
              ClientEventResponse(
                eventDetailsList: _events,
                noOfPages: _totalPagesEvents,
              ),
              isLoadingMore: false,
            ));
          } else if (_currentPageEvents == 0) {
            emit(const ClientEventsStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ClientEventsStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ClientEventsStates.error(message: 'some_error'.tr()));
    } finally {
      _isLoadingEvents = false;
    }
  }

  // For Client Event Details Pagination
  final List<ClientEventDetailsList> _eventDetails = [];
  int _currentPageDetails = 0; // Changed to start from 0 like old code
  int _totalPagesDetails = 1;
  bool _isLoadingDetails = false;

  /// Check if more details pages are available
  bool get hasMoreDetails => _currentPageDetails < _totalPagesDetails - 1;

  /// Reset details pagination
  void resetDetailsPage() {
    _currentPageDetails = 0;
    _eventDetails.clear();
    _totalPagesDetails = 1;
  }

  /// Fetch paginated Client Event Details
  Future<void> getEventDetails(String eventId, {bool isNextPage = false}) async {
    // Don't proceed if already loading or trying to load next page when no more pages
    if (_isLoadingDetails || (!hasMoreDetails && isNextPage)) return;

    try {
      _isLoadingDetails = true;

      if (!isNextPage) {
        resetDetailsPage();
        emit(const ClientEventsStates.loading());
      } else {
        _currentPageDetails++;
        emit(ClientEventsStates.success(
          ClientEventDetailsResponse(eventDetailsList: _eventDetails),
          isLoadingMore: true,
        ));
      }

      final response = await _clientEventsRepo.getClientEventDetails(
        eventId,
        (_currentPageDetails + 1).toString(), // Adding 1 because API expects 1-based index
      );

      await response.when(
        success: (data) async {
          if (data.eventDetailsList != null && data.eventDetailsList!.isNotEmpty) {
            if (_currentPageDetails == 0) {
              _eventDetails.clear();
              _totalPagesDetails = data.noOfPages ?? 1;
            }

            _eventDetails.addAll(data.eventDetailsList!);

            emit(ClientEventsStates.success(
              ClientEventDetailsResponse(
                eventDetailsList: _eventDetails,
                noOfPages: _totalPagesDetails,
              ),
              isLoadingMore: false,
            ));
          } else if (_currentPageDetails == 0) {
            emit(const ClientEventsStates.emptyInput());
          }
        },
        failure: (error) {
          emit(ClientEventsStates.error(message: error.toString()));
        },
      );
    } catch (e) {
      emit(ClientEventsStates.error(message: 'some_error'.tr()));
    } finally {
      _isLoadingDetails = false;
    }
  }
}
