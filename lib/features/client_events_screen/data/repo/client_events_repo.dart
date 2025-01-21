import 'dart:developer';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../home/data/models/profile_response.dart';

class ClientEventsRepo {
  final ApiService _apiService;

  ClientEventsRepo(this._apiService);

  Future<ApiResult<ProfileResponse>> getProfile() async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getProfile(AppUtilities().serverToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
