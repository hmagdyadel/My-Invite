import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/success_response.dart';
import '../models/register_request.dart';

class RegisterRepo {
  final ApiService _apiService;

  RegisterRepo(this._apiService);

    Future<ApiResult<SuccessResponse>> register(RegisterRequest registerRequestBody) async {
    try {
      var response = await _apiService.register(registerRequestBody,);
      if (response.description?.contains('successfully')??false) {
        return ApiResult.success(response);
      }
      return ApiResult.failure(response.description ?? '');
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
