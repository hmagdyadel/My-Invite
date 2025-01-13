import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<ApiResult<LoginResponse>> login(LoginRequest loginRequestBody) async {
    try {
      // Attempt the API call
      var response = await _apiService.login(loginRequestBody);

      // Check if the response contains the necessary data
      if (response.firstName == null) {
        return ApiResult.failure(response.title ?? "login_error");
      }

      // Return success if response is valid
      return ApiResult.success(response);

    } on DioException catch (e) {
      // Handle DioError (e.g., bad response with 401 status code)
      debugPrint('DioError: ${e.message}');

      // If DioError has a response (e.g., HTTP error with details)
      if (e.response != null) {
        final errorResponse = e.response?.data;
        // Check if errorResponse has specific fields and handle accordingly
        if (errorResponse is Map<String, dynamic>) {

          final errorTitle = errorResponse['title'];
          final statusCode = e.response?.statusCode;

          // Map specific error codes to custom error messages
          if (statusCode == 401) {
            return ApiResult.failure("unauthorized_error");
          }

          // Add more conditions based on API behavior
          return ApiResult.failure(errorTitle ?? "login_error");
        }

        // Fallback for unexpected error format
        return ApiResult.failure("unexpected_error");
      }

      // Handle DioError without a response
      return ApiResult.failure("network_error");
    } catch (error) {
      // Handle any other errors not related to Dio
      debugPrint('Unexpected error: $error');
      return ApiResult.failure("unexpected_error");
    }
  }
}
