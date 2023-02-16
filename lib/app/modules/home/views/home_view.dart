import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            ? CameraPreview(controller.camController.value!)
            : const Center(
                child: CircularProgressIndicator(),
              )));
  }
}
