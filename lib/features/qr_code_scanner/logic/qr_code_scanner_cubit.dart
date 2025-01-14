import 'dart:convert';

import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/models/scan_body_request.dart';
import 'qr_code_scanner_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/qr_code_scanner_repo.dart';

class QrCodeScannerCubit extends Cubit<QrCodeScannerStates> {
  final QrCodeScannerRepo _qrCodeScannerRepo;

  QrCodeScannerCubit(this._qrCodeScannerRepo) : super(const QrCodeScannerStates.initial());
  MobileScannerController cameraController = MobileScannerController(facing: CameraFacing.back, detectionSpeed: DetectionSpeed.noDuplicates, autoStart: true);

  bool stopScan = false;

  void dispose() {
    cameraController.dispose();
  }

  String? _scanStartTime;

  String get scanStartTime => _scanStartTime ?? '';

  set scanStartTime(String value) {
    _scanStartTime = value;
  }

  String? _scanEndTime;

  String get scanEndTime => _scanEndTime ?? '';

  set scanEndTime(String value) {
    _scanEndTime = value;
  }

  bool isValidBase64(String str) {
    try {
      base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> scanQrCode(String data) async {
    stopScan = true;
    _scanEndTime = DateTime.now().toString();
    emit(const QrCodeScannerStates.loading());
    ScanBodyRequest scanBodyRequest = ScanBodyRequest(qrCode: data);
    final response = await _qrCodeScannerRepo.scanQrCode(scanBodyRequest);
    response.when(success: (response) {
      stopScan = false;
      emit(QrCodeScannerStates.success(response));
    }, failure: (error) {
      stopScan = false;
      emit(
        QrCodeScannerStates.error(
          message: error.toString(),
        ),
      );
    });
  }
}
