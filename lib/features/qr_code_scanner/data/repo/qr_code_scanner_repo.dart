import '../../../../core/helpers/app_utilities.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../models/scan_body_request.dart';
import '../models/scan_response.dart';

class QrCodeScannerRepo {
  final ApiService _apiService;

  QrCodeScannerRepo(this._apiService);

  Future<ApiResult<ScanResponse>> scanQrCode(ScanBodyRequest scanBodyRequest) async {
    try {
      var response = await _apiService.scanQrCode(scanBodyRequest, AppUtilities().serverToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }
}
