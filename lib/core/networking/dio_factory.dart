import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:io';

import '../helpers/app_utilities.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio() async {
    await AppUtilities.instance
        .importantInitialize(); // Ensure data is loaded before creating Dio
    Duration timeOut = const Duration(seconds: 60); // Increased timeout

    if (dio == null) {
      dio = Dio();

      // Configure basic options
      dio!.options = BaseOptions(
        connectTimeout: timeOut,
        receiveTimeout: timeOut,
        sendTimeout: timeOut,
        headers: {
          "Content-Type": 'application/json; charset=UTF-8',
          "Accept": "application/json",
        },
        responseType: ResponseType.json,
        followRedirects: true,
        validateStatus: (status) {
          // Accept any status code to handle it manually
          return status != null && status < 500;
        },
      );

      // Handle SSL certificates for development/testing
      (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback = (cert, host, port) {
          // Only allow this in development mode
          // In production, remove this or make it more secure
         // print('Warning: Accepting bad certificate for $host:$port');
          return true; // Accept all certificates (for development only)
        };

        // Set additional HTTP client properties
        client.connectionTimeout = timeOut;
        client.idleTimeout = timeOut;

        return client;
      };

      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    // Add retry interceptor first
    dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Retry logic for network errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.connectionError) {

            //print('🔄 Retrying request due to: ${error.type}');

            try {
              // Retry the request once
              final response = await dio?.fetch(error.requestOptions);
              if (response != null) {
                handler.resolve(response);
                return;
              }
            } catch (retryError) {
              //print('❌ Retry failed: $retryError');
            }
          }

          handler.next(error);
        },
      ),
    );

    // Add logging interceptor
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: false,
        maxWidth: 120,
      ),
    );

    // Add custom response/error interceptor
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          //print('🚀 Sending request to: ${options.uri}');
          //print('📱 User Agent: ${Platform.operatingSystem}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          //print('✅ Response Status: ${response.statusCode}');
            //print('✅ Response Headers: ${response.headers}');
          //print('✅ Response Data Type: ${response.data.runtimeType}');
          //print('✅ Response Data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          //print('❌ Error Type: ${error.type}');
          //print('❌ Error Message: ${error.message}');
          //print('❌ Error Status: ${error.response?.statusCode}');
          //print('❌ Error Headers: ${error.response?.headers}');
          //print('❌ Error Data: ${error.response?.data}');
          //print('❌ Request URL: ${error.requestOptions.uri}');
          //print('❌ Request Headers: ${error.requestOptions.headers}');
          //print('❌ Request Data: ${error.requestOptions.data}');

          // Check for specific network issues
          if (error.type == DioExceptionType.unknown && error.error is SocketException) {
            //print('🌐 Socket Exception: ${error.error}');
          }

          handler.next(error);
        },
      ),
    );
  }
}