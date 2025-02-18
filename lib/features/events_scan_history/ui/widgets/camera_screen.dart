import 'dart:io';

import 'package:app/core/helpers/extensions.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller; // Make nullable
  bool initialized = false;
  bool isTakingPicture = false;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  Future<void> _initializeCameraController([int? cameraIndex]) async {
    try {
      // Get available cameras if not already fetched
      if (cameras.isEmpty) {
        cameras = await availableCameras();
      }

      // Use provided index or default to front camera
      if (cameraIndex != null) {
        selectedCameraIndex = cameraIndex;
      } else {
        selectedCameraIndex = cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
        if (selectedCameraIndex == -1) selectedCameraIndex = 0;
      }

      // Dispose previous controller if exists
      if (controller != null) {
        await controller!.dispose();
      }

      // Create and initialize new controller
      controller = CameraController(
        cameras[selectedCameraIndex],
        ResolutionPreset.max,
      );

      await controller!.initialize();
      //await controller!.lockCaptureOrientation(DeviceOrientation.);

      if (!mounted) return;
      setState(() {
        initialized = true;
      });
    } catch (e) {
      _handleCameraError(e, message: "cameraInitFailed".tr());
    }
  }

  void _switchCamera() async {
    setState(() {
      initialized = false;
    });

    final nextIndex = (selectedCameraIndex + 1) % cameras.length;
    await _initializeCameraController(nextIndex);
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
    controller?.dispose(); // Safe disposal with null check
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: publicAppBar(
        context,
        "cameraScreenTitle".tr(),
      ),
      body: initialized && controller != null // Add null check
          ? Stack(
              children: [
                SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Platform.isIOS
                      ? CameraPreview(controller!)
                      : RotatedBox(
                    quarterTurns: 3, // Rotate 270 degrees
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: CameraPreview(controller!),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Switch Camera Button
                        if (cameras.length > 1)
                          FloatingActionButton(
                            heroTag: 'switchCamera',
                            backgroundColor: navBarBackground,
                            onPressed: initialized ? _switchCamera : null,
                            child: const Icon(
                              Icons.flip_camera_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                        // Take Picture Button
                        FloatingActionButton(
                          heroTag: 'takePhoto',
                          backgroundColor: navBarBackground,
                          onPressed: isTakingPicture
                              ? null
                              : () async {
                                  setState(() {
                                    isTakingPicture = true;
                                  });

                                  try {
                                    final XFile file = await controller!.takePicture();
                                    Navigator.pop(context, file);
                                  } catch (e) {
                                    _handleCameraError(e, message: "photoCaptureFailed".tr());
                                  } finally {
                                    setState(() {
                                      isTakingPicture = false;
                                    });
                                  }
                                },
                          child: isTakingPicture ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.camera, color: Colors.white),
                        ),
                      ],
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
