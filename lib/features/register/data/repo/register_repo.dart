import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/location_response.dart';

class RegisterRepo {
  final ApiService _apiService;

  RegisterRepo(this._apiService);

  Future<ApiResult<List<LocationResponse>>> getLocations() async {
    try {
      // Call the API and get the raw response (List of Strings)
      var response = await _apiService.getLocations();

      // Validate the response is a non-empty list
      if (response.isEmpty) {
        return ApiResult.failure("No locations found");
      }

      // Convert the raw response to a list of LocationResponse
      var locations = LocationResponse.fromApiResponse(response);

      // Check if the parsing was successful
      if (locations.isEmpty) {
        return ApiResult.failure("Failed to parse locations");
      }

      return ApiResult.success(locations);
    } catch (error) {
      return ApiResult.failure("Error fetching locations: ${error.toString()}");
    }
  }
}
