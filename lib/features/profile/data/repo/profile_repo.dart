
import 'package:app/features/profile/data/models/profile_response.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';


class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  Future<ApiResult<ProfileResponse>> getProfile() async {
    try {
      var response = await _apiService.getProfile();
      if (response.firstName == null) {
        return ApiResult.failure('failed_to_get_profile'.tr());
      }
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
