import 'package:camera/camera.dart';
import 'package:fatl_mlkit_demo/app/modules/home/views/pose_painter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
          centerTitle: true,
        ),
        body: Obx(() => controller.camController.value != null
            ? CustomPaint(
                painter: PosePainter(
                    controller.poses,
                    controller.absoluteImageSize.value,
                    InputImageRotationValue.fromRawValue(0)!),
                child: CameraPreview(controller.camController.value!),
              )
            : const Center(
                child: CircularProgressIndicator(),
              )));
  }
}
