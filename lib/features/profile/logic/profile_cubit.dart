import '../data/models/profile_response.dart';
import 'profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileStates.initial());

  ProfileResponse? loginResponse;

  void getProfile() async {
    try {
      emit(const ProfileStates.loading());

      final response = await _profileRepo.getProfile();
      response.when(success: (response) {
        emit(ProfileStates.success(response));
      }, failure: (error) {
        emit(ProfileStates.error(message: error.toString()));
      });
    } catch (e) {
      emit(ProfileStates.error(message: e.toString()));
    }
  }
}
