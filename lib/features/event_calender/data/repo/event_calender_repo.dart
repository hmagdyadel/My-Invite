import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/calender_events.dart';

class EventCalenderRepo {
  final ApiService _apiService;

  EventCalenderRepo(this._apiService);

  Future<ApiResult<List<CalenderEventsResponse>>> getEventsCalendar() async {
    try {
      var response = await _apiService.getEventsCalendar(AppUtilities().serverToken);
      debugPrint('success: ${response.toString()}');
      return ApiResult.success(response);
    }on DioException catch (error) {
      debugPrint('Error: ${error.toString()}');
      return ApiResult.failure(error.toString());
    }
    catch (error) {
      debugPrint('Error2: ${error.toString()}');
      return ApiResult.failure(error.toString());
    }
  }
}
