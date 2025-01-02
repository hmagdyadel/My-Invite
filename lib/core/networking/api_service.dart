
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/login/data/models/login_request.dart';
import '../../features/login/data/models/login_response.dart';
import 'api_constants.dart';

part 'api_service.g.dart';
@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;


  @POST(ApiConstants.loginEndpoint)
  Future<LoginResponse> login(
      @Body() LoginRequest loginRequestBody,
      );
}

