import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> _cameras;
late String _model;

class ConeDrill extends StatefulWidget {
  ConeDrill({super.key, required List<CameraDescription> cameras, required String model}) {
    _cameras = cameras;
    _model = model;
  }

  @override
  State<ConeDrill> createState() => _ConeDrill();
}

class _ConeDrill extends State<ConeDrill> {

  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cone Drill")
      ),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) => CameraPreview(controller)
      )
    );
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
    controller.startImageStream((image) async {
      var results = await Tflite.runPoseNetOnFrame(
        bytesList: image.planes.map((plane) {return plane.bytes;}).toList(),
        numResults: 1,
        imageHeight: image.height,
        imageWidth: image.width,
      );
      print(results);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}