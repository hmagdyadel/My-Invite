import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/event_details_response.dart';
import '../models/gatekeeper_events_response.dart';

class GatekeeperEventsRepo {
  final ApiService _apiService;

  GatekeeperEventsRepo(this._apiService);

  Future<ApiResult<GatekeeperEventsResponse>> getGatekeeperEvents(
      String pageNo) async {
    try {
      var response = await _apiService.getGatekeeperEvents(
          pageNo, AppUtilities().serverToken);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<EventDetailsResponse>> getEventDetails(
      String eventId, String pageNo) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getEventDetails(
          AppUtilities().serverToken, eventId, pageNo);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<String>> eventCheckOut(
      String eventId, Position position) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.eventCheckOut(
        AppUtilities().serverToken,
        position.latitude.toString(),
        position.longitude.toString(),
        eventId,
      );
      return ApiResult.success(response);
    } on DioException catch (dioError) {
      // Check if the error message matches the specific condition
      if (dioError.response != null &&
          dioError.response?.data != null &&
          dioError.response!.data
              .toString()
              .contains("This gatekeeper didn't check IN yet to this event")) {
        return ApiResult.failure("not_yet_checked");
      }
      // Return a generic error message for other cases
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<EventDetailsResponse>> eventCheckIn(
      String eventId, String pageNo) async {
    try {
      log(AppUtilities().serverToken);
      var response = await _apiService.getEventDetails(
          AppUtilities().serverToken, eventId, pageNo);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
