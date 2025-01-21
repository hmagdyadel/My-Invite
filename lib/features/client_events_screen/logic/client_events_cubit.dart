import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/client_events_repo.dart';
import 'client_events_states.dart';

class ClientEventsCubit extends Cubit<ClientEventsStates> {
  final ClientEventsRepo _clientEventsRepo;

  ClientEventsCubit(this._clientEventsRepo) : super(const ClientEventsStates.initial());

  void getProfileData() async {
    emit(const ClientEventsStates.loading());
    final response = await _clientEventsRepo.getProfile();
    response.when(success: (response) {
      emit(ClientEventsStates.success(response));
    }, failure: (error) {
      emit(
        ClientEventsStates.error(
          message: error.toString(),
        ),
      );
    });
  }
}
