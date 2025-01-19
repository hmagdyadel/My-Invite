import 'package:app/core/helpers/extensions.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool initialized = false;
  bool isTakingPicture = false;

  // Initialize the camera controller
  Future<void> _initializeCameraController() async {
    try {
      final cameras = await availableCameras();

      // Use the front camera if available
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      controller = CameraController(frontCamera, ResolutionPreset.medium);

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        initialized = true;
      });
    } catch (e) {
      _handleCameraError(e, message: "cameraInitFailed".tr());
    }
  }

  // Handle errors related to the camera
  void _handleCameraError(Object error, {String? message}) {
    final errorMessage = message ?? "unexpectedError".tr();
    context.showErrorToast(errorMessage);

    // Log error for debugging (optional)
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
      appBar: AppBar(
        title: Text("cameraScreenTitle".tr()),
        backgroundColor: navBarBackground,
      ),
      body: initialized
          ? SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CameraPreview(controller),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("cameraLoading".tr(), style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: navBarBackground,
        onPressed: isTakingPicture
            ? null // Prevent multiple presses
            : () async {
          setState(() {
            isTakingPicture = true;
          });

          try {
            final XFile file = await controller.takePicture();
            if (!mounted) return;

            Navigator.of(context).pop(file);
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
    );
  }
}
