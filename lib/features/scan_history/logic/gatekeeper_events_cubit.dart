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

  GatekeeperEventsCubit(this._gatekeeperEventsRepo) : super(const ScanHistoryStates.initial());

  void getGatekeeperEvents({bool isNextPage = false}) async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    if (!isNextPage) {
      _currentPage = 1;
      _events.clear();
      emit(const ScanHistoryStates.loading());
    } else {
      _currentPage++;
    }

    GatekeeperEventsRequest request = GatekeeperEventsRequest(pageNo: _currentPage.toString());
    final response = await _gatekeeperEventsRepo.getGatekeeperEvents(request);
    response.when(success: (data) {
      if (data.entityList != null && data.entityList!.isNotEmpty) {
        _events.addAll(data.entityList!);
        _hasMore = data.entityList!.length >= 10; // Assume 10 items per page
        emit(ScanHistoryStates.success(GatekeeperEventsResponse(entityList: _events)));
      } else {
        _hasMore = false;
        if (!isNextPage) emit(const ScanHistoryStates.emptyInput());
      }
    }, failure: (error) {
      if (!isNextPage) {
        emit(ScanHistoryStates.error(message: error.toString()));
      }
    });

    _isLoading = false;
  }
}

