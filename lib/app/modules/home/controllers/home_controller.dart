import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class HomeController extends GetxController {
  Rx<CameraController?> camController = Rx<CameraController?>(null);
  RxList<Pose> poses = RxList<Pose>([]);
  Rx<Size> absoluteImageSize = Rx<Size>(const Size(0, 0));
  

  @override
  void onInit() async {
    super.onInit();

    // Initialize the camera controller
    camController.value = await _initCamera();

    // Initialize the pose detector
    var poseDetector = _initPoseDetector();

    // Start the pose detection
    _startPoseDetection(poseDetector);
  }

  Future<CameraController> _initCamera() async {
    // Get the list of available cameras
    final cameras = await availableCameras();

    // Initialize the camera controller
    // Index 1 is the front facing camera
    var controller = CameraController(cameras[1], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  PoseDetector _initPoseDetector() {
    final options = PoseDetectorOptions(
        model: PoseDetectionModel.accurate, mode: PoseDetectionMode.stream);
    return PoseDetector(options: options);
  }

  void _startPoseDetection(PoseDetector poseDetector) async {
    // Start camera streaming
    await camController.value!.startImageStream((image) async {
      // Detect poses
      final newPoses = await poseDetector
          .processImage(_createInputImageFromCameraImage(image));

      // Assign RxList to the new poses
      poses.value = newPoses;
    });
  }

  InputImage _createInputImageFromCameraImage(CameraImage cameraImage) {
    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    absoluteImageSize.value = imageSize;

    final InputImageRotation? imageRotation =
        InputImageRotationValue.fromRawValue(0);

    final InputImageFormat? inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw);

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: cameraImage.planes[0].bytes,
      inputImageData: inputImageData,
    );

    return inputImage;
  }
}
