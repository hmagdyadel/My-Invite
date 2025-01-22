import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/client_events_screen/data/models/client_event_details_response.dart';
import '../../features/client_events_screen/data/models/client_event_response.dart';
import '../../features/client_events_screen/data/models/client_messages_status_response.dart';
import '../../features/event_calender/data/models/calender_events.dart';
import '../../features/home/data/models/profile_response.dart';
import '../../features/location/data/models/city_response.dart';
import '../../features/location/data/models/country_response.dart';
import '../../features/login/data/models/login_request.dart';
import '../../features/login/data/models/login_response.dart';
import '../../features/qr_code_scanner/data/models/scan_body_request.dart';
import '../../features/qr_code_scanner/data/models/scan_response.dart';
import '../../features/register/data/models/location_response.dart';
import '../../features/register/data/models/register_request.dart';
import '../../features/scan_history/data/models/event_details_response.dart';
import '../../features/scan_history/data/models/gatekeeper_events_response.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.loginEndpoint)
  Future<LoginResponse> login(
    @Body() LoginRequest loginRequestBody,
  );

  @GET(ApiConstants.locationsEndpoint)
  Future<List<LocationResponse>> getLocations();

  @GET(ApiConstants.countriesEndpoint)
  Future<List<CountryResponse>> getCountries();

  @GET("${ApiConstants.citiesEndpoint}/{countryId}")
  Future<List<CityResponse>> getCities(
    @Path("countryId") int countryId,
  );

  @POST(ApiConstants.registerEndpoint)
  Future<String> register(
    @Body() RegisterRequest registerRequestBody,
  );

  @GET(ApiConstants.clientProfileEndpoint)
  Future<ProfileResponse> getProfile(
    @Header('Authorization') String token,
  );

  @POST(ApiConstants.scanEndpoint)
  Future<ScanResponse> scanQrCode(
    @Body() ScanBodyRequest scanBodyRequest,
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.gatekeeperEventsEndpoint)
  Future<GatekeeperEventsResponse> getGatekeeperEvents(
    @Header('pageNo') String pageNo,
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.scanHistoryEndpoint)
  Future<EventDetailsResponse> getEventDetails(
    @Header('Authorization') String token,
    @Header('eventId') String eventId,
    @Header('pageNo') String pageNo,
  );

  @GET(ApiConstants.checkoutEndpoint)
  Future<String> eventCheckOut(
    @Header('Authorization') String token,
    @Header('latitude') String latitude,
    @Header('longitude') String longitude,
    @Query('eventid') String eventId,
  );

  @POST(ApiConstants.checkinEndpoint)
  Future<String> eventCheckIn(
    @Header('Authorization') String token,
    @Header('latitude') String latitude,
    @Header('longitude') String longitude,
    @Query('eventId') String eventId,
    @Body() FormData formData,
  );

  @GET(ApiConstants.calendarEventsEndpoint)
  Future<List<CalenderEventsResponse>> getEventsCalendar(
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.reserveEventEndpoint)
  Future<String> reserveEvent(
    @Header('Authorization') String token,
    @Query('eventid') String eventId,
  );

  @GET(ApiConstants.clientEvents)
  Future<ClientEventResponse> getClientEvents(
    @Header('pageNo') String pageNo,
    @Header('Authorization') String token,
  );

  @GET(ApiConstants.clientEventDetailsEndpoint)
  Future<ClientEventDetailsResponse> getClientEventDetails(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
  );

  @GET(ApiConstants.messageStatusEndpoint)
  Future<ClientMessagesStatusResponse> getClientMessagesStatus(
    @Header('Authorization') String token,
    @Header('pageNo') String pageNo,
    @Query('eventId') String eventId,
  );
}
