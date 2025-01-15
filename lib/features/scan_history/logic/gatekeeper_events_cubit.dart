import '../data/models/gatekeeper_events_request.dart';
import '../data/repo/gatekeeper_events_repo.dart';
import 'scan_history_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GatekeeperEventsCubit extends Cubit<ScanHistoryStates> {
  final GatekeeperEventsRepo _gatekeeperEventsRepo;

  GatekeeperEventsCubit(this._gatekeeperEventsRepo) : super(const ScanHistoryStates.initial());

  void getGatekeeperEvents() async {
    emit(const ScanHistoryStates.loading());
    GatekeeperEventsRequest gatekeeperEventsRequest = GatekeeperEventsRequest(pageNo: 1.toString());
    final response = await _gatekeeperEventsRepo.getGatekeeperEvents(gatekeeperEventsRequest);
    response.when(success: (response) {
      emit(ScanHistoryStates.emptyInput());
    }, failure: (error) {
      emit(
        ScanHistoryStates.error(
          message: error.toString(),
        ),
      );
    });
  }
}
