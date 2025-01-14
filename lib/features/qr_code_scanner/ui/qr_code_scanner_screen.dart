import 'package:app/core/widgets/normal_text.dart';
import 'package:app/core/widgets/public_appbar.dart';
import 'package:app/features/qr_code_scanner/logic/qr_code_scanner_cubit.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:app/core/helpers/extensions.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theming/colors.dart';
import '../../../core/widgets/loaders.dart';
import '../data/models/scan_response.dart';
import '../logic/qr_code_scanner_states.dart';

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
          : BlocBuilder<QrCodeScannerCubit, QrCodeScannerStates>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, current) {
                return current.when(
                  initial: () => _scannerView(context, cubit),
                  loading: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (Navigator.canPop(context)) return;
                      animatedLoaderWithTitle(context: context, title: "wait".tr());
                    });
                    return const SizedBox.shrink();
                  },
                  emptyInput: () => const SizedBox.shrink(),
                  success: (response) => _handleSuccess(context, response),
                  error: (error) => _handleError(context, error),
                );
              },
            ),
    );
  }

  Widget _scannerView(BuildContext context, QrCodeScannerCubit cubit) {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (capture) async {
            if (cubit.stopScan) return; // Skip if already scanning
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
    );
  }

  Widget _handleSuccess(BuildContext context, ScanResponse response) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService().playAudio(
        src: 'sounds/audSuccess.mp3',
        onComplete: () {
          _showColoredAlert(
            context: context,
            title: "qr_verified".tr(),
            message: response.message ?? "",
            correct: true,
            color: Colors.lightGreen,
            onClose: () {
              context.read<QrCodeScannerCubit>().reloadPage();
            },
          );
        },
      );
    });
    return const SizedBox.shrink();
  }


  Widget _handleError(BuildContext context, String error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (error.contains("Scanned 1 of 1")) {
        context.showErrorToast("scanned_before".tr());
      } else {
        context.showErrorToast(error);
      }

      context.read<QrCodeScannerCubit>().reloadPage();
    });
    return const SizedBox.shrink();
  }

  void _showColoredAlert({
    required BuildContext context,
    required String title,
    required bool correct,
    required String message,
    required Color color,
    required VoidCallback onClose,
  }) {
    Widget okButton = TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(primaryColor),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        onClose();
      },
      child: const NormalText(
        text: "Continue",
        color: Colors.white,
        fontSize: 16,
      ),
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: color,
      title: Column(
        children: [
          correct
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 46,
                )
              : const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 46,
                ),
          const SizedBox(
            height: 12,
          ),
          NormalText(
            text: title,
            color: Colors.black,
          ),
        ],
      ),
      content: NormalText(
        text: message,
        fontSize: 14,
        color: Colors.black,
      ),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
