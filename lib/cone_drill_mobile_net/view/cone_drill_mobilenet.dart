import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> _cameras;

class ConeDrillMobilenet extends StatefulWidget {
  ConeDrillMobilenet({super.key, required List<CameraDescription> cameras}) {
    _cameras = cameras;
  }

  @override
  State<ConeDrillMobilenet> createState() => _ConeDrill();
}

class _ConeDrill extends State<ConeDrillMobilenet> {

  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  double previewWidth = 0;
  double previewHeight = 0;
  bool isDetecting = false;

  @override
  Widget build(BuildContext context) {

    // {
    //   detectedClass: "hot dog",
    // confidenceInClass: 0.123,
    // rect: {
    // x: 0.15,
    // y: 0.33,
    // w: 0.80,
    // h: 0.27
    // }
    // }


    return Scaffold(
      appBar: AppBar(title: Text("Cone"),),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            //TODO: Check if other states need to be handled explicitly
            if (!(snapshot.connectionState == ConnectionState.done)) {
              //TODO: Replace with loading icon, extract shared widget
              return const Icon(Icons.downloading);
            }
            return Stack(
              children: [
                OrientationBuilder(builder: (context, orientation) {
                  return AspectRatio(
                      aspectRatio: orientation == Orientation.portrait ? 1 / controller.value.aspectRatio : controller.value.aspectRatio,
                      child: CameraPreview(controller)
                  );
                }),
              ],
            );
          })
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    controller = CameraController(_cameras[0], ResolutionPreset.low);
    _initializeControllerFuture = controller.initialize().then((_) {
      previewHeight = MediaQuery.of(context).size.height - 90; //TODO: Calculator size of app bar at runtime
      previewWidth = previewHeight * controller.value.aspectRatio;
      setState(() {});

      controller.startImageStream((image) async {
        if (isDetecting) {
          return;
        }
        isDetecting = true;
        Tflite.detectObjectOnFrame(
            bytesList: image.planes.map((plane) => plane.bytes).toList(),
            model: "SSDMobileNet",
            rotation: 180, // 180 for landscapeRight, 90 for portrait
            imageHeight: image.height,
            imageWidth: image.width
        ).then((results) {
          print(results);
          isDetecting = false;
        });
      });
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    controller.dispose();
    await Tflite.close();
  }
}