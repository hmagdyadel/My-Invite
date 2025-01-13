import 'package:app/features/home/logic/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeStates.initial());

  void getProfileData() async {
    emit(const HomeStates.loading());
    final response = await _homeRepo.getProfile();
    response.when(success: (response) {
      emit(HomeStates.success(response));
    }, failure: (error) {
      emit(
        HomeStates.error(
          message: error.toString(),
        ),
      );
    });
  }
}
