
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<ApiResult<LoginResponse>> login(LoginRequest loginRequestBody) async {
    try {
      var response = await _apiService.login(loginRequestBody);
      if (response.firstName == null) {
        return ApiResult.failure(response.title ?? '');
      }
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
