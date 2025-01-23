import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../../../client_events/data/models/client_event_response.dart';
import '../models/client_messages_statistics_response.dart';

class ClientStatisticsRepo {
  final ApiService _apiService;

  ClientStatisticsRepo(this._apiService);

  Future<ApiResult<ClientEventResponse>> getClientEvents(String pageNo) async {
    try {
      var response = await _apiService.getClientEvents(pageNo, AppUtilities().serverToken);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  Future<ApiResult<ClientMessagesStatisticsResponse>> getClientMessageStatistics(String eventId) async {
    try {
      var response = await _apiService.getClientMessageStatistics( AppUtilities().serverToken,eventId);
      return ApiResult.success(response);
    } on DioException {
      return ApiResult.failure("some_error".tr());
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
