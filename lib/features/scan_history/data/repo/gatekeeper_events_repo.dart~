import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/gatekeeper_events_request.dart';
import '../models/gatekeeper_events_response.dart';

class GatekeeperEventsRepo {
  final ApiService _apiService;

  GatekeeperEventsRepo(this._apiService);

  Future<ApiResult<GatekeeperEventsResponse>> getGatekeeperEvents(GatekeeperEventsRequest gatekeeperEventsRequest) async {
    try {
      var response = await _apiService.getGatekeeperEvents(gatekeeperEventsRequest, AppUtilities().serverToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
