import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> _cameras;

class ConeDrillPosenet extends StatefulWidget {
  ConeDrillPosenet({super.key, required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

  @override
  State<ConeDrillPosenet> createState() => _ConeDrill();
}

class _ConeDrill extends State<ConeDrillPosenet> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  double previewW = 0;
  double previewH = 0;
  dynamic rightHandResult = Map.of({});
  dynamic leftHandResult = Map.of({});
  bool isDetecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cone"),
        ),
        body: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  OrientationBuilder(builder: (context, orientation) {
                    return AspectRatio(
                        aspectRatio: orientation == Orientation.portrait
                            ? 1 / controller.value.aspectRatio
                            : controller.value.aspectRatio,
                        child: CameraPreview(controller));
                  }),
                  Positioned(
                      top: leftHandResult.isEmpty
                          ? 0
                          : leftHandResult["y"] * previewH - 12,
                      left: leftHandResult.isEmpty
                          ? 0
                          : leftHandResult["x"] * previewW - 12,
                      child: const Icon(
                        Icons.circle,
                        color: Colors.cyan,
                      )),
                  Positioned(
                      top: rightHandResult.isEmpty
                          ? 0
                          : rightHandResult["y"] * previewH - 12,
                      left: rightHandResult.isEmpty
                          ? 0
                          : rightHandResult["x"] * previewW - 12,
                      child: const Icon(
                        Icons.circle,
                        color: Colors.red,
                      )),
                ],
              );
            }));
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    controller = CameraController(_cameras[0], ResolutionPreset.low);
    _initializeControllerFuture = controller.initialize().then((_) {
      previewH = MediaQuery.of(context).size.height -
          90; //TODO: Calculator size of app bar at runtime
      previewW = previewH * controller.value.aspectRatio;
      setState(() {});

      controller.startImageStream((image) async {
        if (isDetecting) {
          return;
        }
        isDetecting = true;
        Tflite.runPoseNetOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          numResults: 1,
          imageHeight: image.height,
          imageWidth: image.width,
          rotation: 180,
        ).then((results) {
          if (results!.isNotEmpty &&
              results[0]["keypoints"][9]["score"] > 0.5 &&
              results[0]["keypoints"][10]["score"] > 0.5) {
            leftHandResult = results[0]["keypoints"][9];
            rightHandResult = results[0]["keypoints"][10];
            setState(() {});
          }
          isDetecting = false;
        });
      });
    });
  }

  @override
  Future<void> dispose() async {
    controller.dispose();
    await Tflite.close();
    super.dispose();
  }
}
