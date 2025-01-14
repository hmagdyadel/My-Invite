import 'package:app/core/widgets/public_appbar.dart';
import 'package:app/features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theming/colors.dart';

class QrCodeScannerScreen extends StatefulWidget {
  const QrCodeScannerScreen({super.key});

  @override
  State<QrCodeScannerScreen> createState() => _QrCodeScannerScreenState();
}

class _QrCodeScannerScreenState extends State<QrCodeScannerScreen> {
  @override
  void dispose() {
    context.read<QrCodeScannerCubit>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QrCodeScannerCubit>();
    return Scaffold(
      backgroundColor: bgColor,
      body: cubit.stopScan
          ? Container(color: Colors.black)
          : Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) async {
                    cubit.scanStartTime = DateTime.now().toString();
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (cubit.isValidBase64(barcode.rawValue ?? "")) {
                        debugPrint('Barcode found! ${barcode.rawValue}');
                        await cubit.scanQrCode(barcode.rawValue!);
                      } else {
                        debugPrint('Not valid barcode ${barcode.rawValue}');
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 110,
                  child: publicAppBar(context, "scan".tr()),
                ),
              ],
            ),
    );
  }
}
