import '../data/models/gatekeeper_events_request.dart';
import '../data/models/gatekeeper_events_response.dart';
import '../data/repo/gatekeeper_events_repo.dart';
import 'scan_history_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GatekeeperEventsCubit extends Cubit<ScanHistoryStates> {
  final GatekeeperEventsRepo _gatekeeperEventsRepo;

  final List<EventsList> _events = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  GatekeeperEventsCubit(this._gatekeeperEventsRepo)
      : super(const ScanHistoryStates.initial());

  Future<void> getGatekeeperEvents({bool isNextPage = false}) async {
    if (_isLoading || (!_hasMore && isNextPage)) return;

    _isLoading = true;
    if (!isNextPage) {
      _currentPage = 1;
      _events.clear();
      emit(const ScanHistoryStates.loading());
    } else {
      // For next pages, emit success state with current events and loading flag
      emit(ScanHistoryStates.success(
        GatekeeperEventsResponse(entityList: _events),
        isLoadingMore: true,
      ));
    }

    try {
      GatekeeperEventsRequest request =
      GatekeeperEventsRequest(pageNo: _currentPage.toString());
      final response = await _gatekeeperEventsRepo.getGatekeeperEvents(request);

      await response.when(
        success: (data) async {
          if (data.entityList != null && data.entityList!.isNotEmpty) {
            if (!isNextPage) _events.clear();
            _events.addAll(data.entityList!);
            _hasMore = data.noOfPages != null && _currentPage < data.noOfPages!;
            _currentPage++;
            emit(ScanHistoryStates.success(
              GatekeeperEventsResponse(entityList: _events),
              isLoadingMore: false,
            ));
          } else {
            _hasMore = false;
            if (!isNextPage) {
              emit(const ScanHistoryStates.emptyInput());
            } else {
              // If no more data on next page, emit current list with loading false
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
            // On error during pagination, keep current list visible
            emit(ScanHistoryStates.success(
              GatekeeperEventsResponse(entityList: _events),
              isLoadingMore: false,
            ));
          }
        },
      );
    } finally {
      _isLoading = false;
    }
  }

  bool get hasMore => _hasMore;
}

