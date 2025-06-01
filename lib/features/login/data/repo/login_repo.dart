import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<ApiResult<LoginResponse>> login(LoginRequest loginRequestBody) async {
    try {
      debugPrint('🚀 Starting login request for user: ${loginRequestBody.username}');

      // Attempt the API call
      var response = await _apiService.login(loginRequestBody);

      debugPrint('✅ Login API call successful');
      debugPrint('✅ Response type: ${response.runtimeType}');
      debugPrint('✅ Response data: $response');

      // Check if the response contains the necessary data for a successful login
      if (response.token?.isNotEmpty == true && response.firstName?.isNotEmpty == true) {
        debugPrint('✅ Login successful for user: ${response.firstName}');
        return ApiResult.success(response);
      } else {
        debugPrint('❌ Login response missing required fields');
        debugPrint('Token present: ${response.token?.isNotEmpty}');
        debugPrint('FirstName present: ${response.firstName?.isNotEmpty}');
        return ApiResult.failure(response.title ?? "login_error");
      }

    } on DioException catch (e) {
      debugPrint('❌ DioException caught');
      debugPrint('Error type: ${e.type}');
      debugPrint('Error message: ${e.message}');
      debugPrint('Error response: ${e.response}');
      debugPrint('Error response data: ${e.response?.data}');
      debugPrint('Error response data type: ${e.response?.data.runtimeType}');
      debugPrint('Underlying error: ${e.error}');

      // Handle different types of DioExceptions
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          debugPrint('🕐 Connection timeout');
          return ApiResult.failure("connection_timeout");

        case DioExceptionType.sendTimeout:
          debugPrint('🕐 Send timeout');
          return ApiResult.failure("send_timeout");

        case DioExceptionType.receiveTimeout:
          debugPrint('🕐 Receive timeout');
          return ApiResult.failure("receive_timeout");

        case DioExceptionType.connectionError:
          debugPrint('🌐 Connection error');
          if (e.error is SocketException) {
            final socketException = e.error as SocketException;
            debugPrint('Socket error: ${socketException.message}');
            debugPrint('Socket address: ${socketException.address}');
            debugPrint('Socket port: ${socketException.port}');

            // Check for specific network issues
            if (socketException.message.contains('No address associated with hostname')) {
              return ApiResult.failure("dns_error");
            } else if (socketException.message.contains('Connection refused')) {
              return ApiResult.failure("connection_refused");
            } else if (socketException.message.contains('Network is unreachable')) {
              return ApiResult.failure("network_unreachable");
            }
          }
          return ApiResult.failure("connection_error");

        case DioExceptionType.badCertificate:
          debugPrint('🔒 Bad certificate');
          return ApiResult.failure("ssl_error");

        case DioExceptionType.cancel:
          debugPrint('❌ Request cancelled');
          return ApiResult.failure("request_cancelled");

        case DioExceptionType.unknown:
          debugPrint('❓ Unknown error');
          if (e.error is SocketException) {
            debugPrint('Socket exception in unknown error: ${e.error}');
            return ApiResult.failure("network_error");
          } else if (e.error is HandshakeException) {
            debugPrint('SSL handshake exception: ${e.error}');
            return ApiResult.failure("ssl_handshake_error");
          }
          return ApiResult.failure("unknown_network_error");

        case DioExceptionType.badResponse:
          debugPrint('📱 Bad response');
          // Handle HTTP error responses
          if (e.response != null) {
            switch (e.response?.statusCode) {
              case 400:
                return _handleBadRequestError(e.response!);
              case 401:
                return ApiResult.failure("unauthorized_error");
              case 403:
                return ApiResult.failure("forbidden_error");
              case 404:
                return ApiResult.failure("not_found_error");
              case 500:
                return ApiResult.failure("server_error");
              default:
                return _extractErrorFromResponse(e.response!);
            }
          }
          return ApiResult.failure("bad_response");
      }

    } on SocketException catch (e) {
      debugPrint('🌐 Direct SocketException: ${e.message}');
      debugPrint('Address: ${e.address}');
      debugPrint('Port: ${e.port}');
      return ApiResult.failure("network_connection_error");

    } catch (error) {
      debugPrint('❌ Unexpected error: $error');
      debugPrint('Error type: ${error.runtimeType}');
      return ApiResult.failure("unexpected_error");
    }
  }

  ApiResult<LoginResponse> _handleBadRequestError(Response response) {
    // Check if response data is a string first
    if (response.data is String) {
      final errorMsg = response.data.toString();
      debugPrint('400 Error message (String): $errorMsg');
      if (errorMsg.toLowerCase().contains("account not approved")) {
        return ApiResult.failure("account_not_approved");
      }
      return ApiResult.failure("invalid_credentials");
    }
    // Try to handle as JSON object if it's not a string
    else if (response.data is Map<String, dynamic>) {
      final errorResponse = response.data as Map<String, dynamic>;
      final errorTitle = errorResponse['title'] ?? errorResponse['message'];
      debugPrint('400 Error message (JSON): $errorTitle');

      if (errorTitle != null &&
          errorTitle.toString().toLowerCase().contains("account not approved")) {
        return ApiResult.failure("account_not_approved");
      }
      return ApiResult.failure(errorTitle ?? "invalid_credentials");
    }
    return ApiResult.failure("invalid_credentials");
  }

  ApiResult<LoginResponse> _extractErrorFromResponse(Response response) {
    if (response.data is Map<String, dynamic>) {
      final errorResponse = response.data as Map<String, dynamic>;
      final errorTitle = errorResponse['title'] ?? errorResponse['message'];
      return ApiResult.failure(errorTitle ?? "server_error");
    }
    return ApiResult.failure("server_error");
  }
}