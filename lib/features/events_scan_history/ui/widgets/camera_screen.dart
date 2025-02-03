import 'package:app/core/helpers/extensions.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool initialized = false;
  bool isTakingPicture = false;

  Future<void> _initializeCameraController() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      controller = CameraController(
        frontCamera,
        ResolutionPreset.max,
      );

      await controller.initialize();
      await controller.lockCaptureOrientation(DeviceOrientation.portraitDown); // Lock to portrait

      if (!mounted) return;
      setState(() {
        initialized = true;
      });
    } catch (e) {
      _handleCameraError(e, message: "cameraInitFailed".tr());
    }
  }

  void _handleCameraError(Object error, {String? message}) {
    final errorMessage = message ?? "unexpectedError".tr();
    context.showErrorToast(errorMessage);
    debugPrint('Camera Error: $error');
  }

  @override
  void initState() {
    super.initState();
    _initializeCameraController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: publicAppBar(
        context,
        "cameraScreenTitle".tr(),
      ),
      body: initialized
          ? Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RotatedBox(
              quarterTurns: controller.description.sensorOrientation == 270 ? 1 : 3,
              child: CameraPreview(controller),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: FloatingActionButton(
                backgroundColor: navBarBackground,
                onPressed: isTakingPicture
                    ? null
                    : () async {
                  setState(() {
                    isTakingPicture = true;
                  });

                  try {
                    final XFile file = await controller.takePicture();
                    Navigator.pop(context, file);
                  } catch (e) {
                    _handleCameraError(e, message: "photoCaptureFailed".tr());
                  } finally {
                    setState(() {
                      isTakingPicture = false;
                    });
                  }
                },
                child: isTakingPicture
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.camera, color: Colors.white),
              ),
            ),
          ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text("cameraLoading".tr(), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
