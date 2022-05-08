// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/request_camera_permsion.dart';
import '../widgets/error_component.dart';
import '../widgets/camera_target.dart';

import './processing_screen.dart';

class HomePage extends StatelessWidget {
  final CameraDescription camera;
  const HomePage(this.camera, {Key? key}) : super(key: key);

  static const String routeName = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blind App"),
        centerTitle: true,
      ),
      body: _CameraComponent(camera),
    );
  }
}

class _CameraComponent extends StatefulWidget {
  final CameraDescription camera;
  const _CameraComponent(this.camera, {Key? key}) : super(key: key);

  @override
  State<_CameraComponent> createState() => __CameraComponentState();
}

class __CameraComponentState extends State<_CameraComponent> {
  late CameraController controller;
  late Future<void> _initalizeCamera;
  late Future<bool> _isCameraPermsionGranted;

  @override
  void initState() {
    print("init state ran in camera controler widget");
    _isCameraPermsionGranted = getPermisonStatus();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> getPermisonStatus() async {
    try {
      await Permission.camera.request();
      if (await Permission.camera.status.isGranted) {
        controller = CameraController(
          widget.camera,
          ResolutionPreset.medium,
        );

        _initalizeCamera = controller.initialize();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("exception caught $e");
      log("exception caught $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isCameraPermsionGranted,
        builder: (context, AsyncSnapshot<bool> cameraPermisonSnapShot) {
          if (cameraPermisonSnapShot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!(cameraPermisonSnapShot.data as bool)) {
            //if permsion is denied
            return RequestCameraPermision(() {
              _isCameraPermsionGranted = getPermisonStatus();
              setState(() {});
            });
          } else if (cameraPermisonSnapShot.hasError) {
            return ErrorComponent("An error occured while accessing camera");
          }
          return FutureBuilder(
            future: _initalizeCamera,
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapShot.hasError) {
                return ErrorComponent("An error occured while loading camera");
              } else {
                final scale = 1 /
                    (controller.value.aspectRatio *
                        MediaQuery.of(context).size.aspectRatio);
                final screenSize = MediaQuery.of(context).size;

                return SizedBox(
                  height: screenSize.height,
                  width: screenSize.width,
                  child:
                      _buildDisplayStack(scale: scale, controller: controller),
                );
              }
            },
          );
        });
  }
}

class _buildDisplayStack extends StatelessWidget {
  const _buildDisplayStack({
    Key? key,
    required this.scale,
    required this.controller,
  }) : super(key: key);

  final double scale;
  final CameraController controller;
  void _whenCameraTargetPressed(BuildContext context) async {
    print("camera target pressed");

    final pickedImage = await controller.takePicture();

    Navigator.of(context).pushNamed(
      ProcessingScreen.routeName,
      arguments: pickedImage.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: CameraPreview(controller),
        ),
        Center(
          child: CameraTarget(() {
            _whenCameraTargetPressed(context);
          }),
        ),
      ],
    );
  }
}
