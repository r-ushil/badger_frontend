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
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<dynamic> _results = List.empty();
  double _previewWidth = 0;
  double _previewHeight = 0;
  bool _isDetecting = false;

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
        appBar: AppBar(
          title: Text("Cone"),
        ),
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
                        aspectRatio: orientation == Orientation.portrait
                            ? 1 / _controller.value.aspectRatio
                            : _controller.value.aspectRatio,
                        child: CameraPreview(_controller));
                  }),
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

    _controller = CameraController(_cameras[0], ResolutionPreset.low);
    _initializeControllerFuture = _controller.initialize().then((_) {
      _previewHeight = MediaQuery.of(context).size.height -
          90; //TODO: Calculator size of app bar at runtime
      _previewWidth = _previewHeight * _controller.value.aspectRatio;
      setState(() {});

      _controller.startImageStream((image) async {
        if (_isDetecting) {
          return;
        }
        _isDetecting = true;
        Tflite.detectObjectOnFrame(
                bytesList: image.planes.map((plane) => plane.bytes).toList(),
                model: "SSDMobileNet",
                rotation: 180, // 180 for landscapeRight, 90 for portrait
                imageHeight: image.height,
                imageWidth: image.width)
            .then((results) {
          print(results);
          _isDetecting = false;
        });
      });
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _controller.dispose();
    await Tflite.close();
  }
}
