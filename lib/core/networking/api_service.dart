import 'package:app/core/networking/success_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/location/data/models/city_response.dart';
import '../../features/location/data/models/country_response.dart';
import '../../features/login/data/models/login_request.dart';
import '../../features/login/data/models/login_response.dart';
import '../../features/profile/data/models/profile_response.dart';
import '../../features/register/data/models/location_response.dart';
import '../../features/register/data/models/register_request.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.loginEndpoint)
  Future<LoginResponse> login(@Body() LoginRequest loginRequestBody);

  @GET(ApiConstants.clientProfileEndpoint)
  Future<ProfileResponse> getProfile();

  @GET(ApiConstants.locationsEndpoint)
  Future<List<LocationResponse>> getLocations();

  @GET(ApiConstants.countriesEndpoint)
  Future<List<CountryResponse>> getCountries();

  @GET("${ApiConstants.citiesEndpoint}/{countryId}")
  Future<List<CityResponse>> getCities(@Path("countryId") int countryId);
  @POST(ApiConstants.registerEndpoint)
  Future<SuccessResponse> register(@Body() RegisterRequest registerRequestBody);
}
