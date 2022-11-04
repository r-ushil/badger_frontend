import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

late List<CameraDescription> _cameras;

// TODO: make sure this class is in the correct place
class BoundingBox {
  BoundingBox(this.x, this.y, this.width, this.height, this.className,
      this.confidenceScore);

  double x;
  double y;
  double width;
  double height;
  String className;
  double confidenceScore;
}

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
  BoundingBox? personBoundingBox;
  BoundingBox? leftBottleBoundingBox;
  BoundingBox? rightBottleBoundingBox;
  double _previewWidth = 0;
  double _previewHeight = 0;
  bool _isDetecting = false;

  static const confidenceThreshold = 0.5;

  BoundingBox mobileNetResultToBoundingBox(dynamic result) {
    var rectangle = result["rect"];
    return BoundingBox(rectangle["x"], rectangle["y"], rectangle["w"],
        rectangle["h"], result["detectedClass"], result["confidenceInClass"]);
  }

  void updateBoundingBoxesFromMobilenetResults(List? results) {
    //no results returned from mobilenet
    if (results == null) {
      return;
    }

    // maximum of 2 results per class so filteredResults has a max of 4 elements
    var filteredResults = results.where((result) =>
        result["detectedClass"] == "person" ||
        result["detectedClass"] == "bottle");

    filteredResults = results
        .where((result) => result["confidenceInClass"] > confidenceThreshold);

    for (var result in filteredResults) {
      var boundingBox = mobileNetResultToBoundingBox(result);
      if (boundingBox.className == "person") {
        personBoundingBox = boundingBox;
      } else if (boundingBox.className == "bottle") {
        //TODO: replace with more thorough way to distinguish left and right bottles
        if (boundingBox.x > 0.5) {
          rightBottleBoundingBox = boundingBox;
        } else {
          leftBottleBoundingBox = boundingBox;
        }
      }
    }
    setState(() {});
  }

  Widget boundingBoxToWidget(BoundingBox? boundingBox) {
    if (boundingBox == null) {
      //TODO: handler case when bounding box not initialised better
      return Container();
    }
    return Positioned(
      top: boundingBox.y * _previewHeight,
      left: boundingBox.x * _previewWidth,
      width: boundingBox.width * _previewWidth,
      height: boundingBox.height * _previewHeight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(37, 213, 253, 1.0),
            width: 3.0,
          ),
        ),
        child: Text(boundingBox.className),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cone"),
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
                  boundingBoxToWidget(personBoundingBox),
                  boundingBoxToWidget(leftBottleBoundingBox),
                  boundingBoxToWidget(rightBottleBoundingBox)
                ],
              );
            }));
  }

  @override
  void initState() {
    super.initState();

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
                numResultsPerClass: 2,
                rotation: 180, // 180 for landscapeRight, 90 for portrait
                imageHeight: image.height,
                imageWidth: image.width)
            .then((results) {
          updateBoundingBoxesFromMobilenetResults(results);
          setState(() {});
          _isDetecting = false;
        });
      });
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    await Tflite.close();
  }
}
