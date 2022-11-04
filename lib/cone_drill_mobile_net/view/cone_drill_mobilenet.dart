import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:statemachine/statemachine.dart' as state;

late List<CameraDescription> _cameras;

enum DrillStatus { notReady, ready, runningThere, runningBack, finished }

enum GoalCone { firstCone, secondCone }

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

  static bool areColliding(BoundingBox box1, BoundingBox box2) {
    return box1.x < box2.x + box2.width &&
        box1.x + box1.width > box2.x &&
        box1.y < box2.y + box2.height &&
        box1.height + box1.y > box2.y;
  }
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
  final state.Machine<DrillStatus> _drillStatusStateMachine =
      state.Machine<DrillStatus>();
  bool _startButtonVisible = false;
  final _stopwatch = Stopwatch();

  static const confidenceThreshold = 0.5;
  
  int _sprintLegs = 0;

  // GoalCone? _goalCone; TODO: uncomment

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

  Widget boundingBoxToWidget(BoundingBox? boundingBox, Color color) {
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
            color: color,
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
              var collidingWithLeftBottle = personBoundingBox != null &&
                  leftBottleBoundingBox != null &&
                  BoundingBox.areColliding(
                      personBoundingBox!, leftBottleBoundingBox!);

              var collidingWithRightBottle = personBoundingBox != null &&
                  rightBottleBoundingBox != null &&
                  BoundingBox.areColliding(
                      personBoundingBox!, rightBottleBoundingBox!);
              var red = const Color.fromRGBO(255, 0, 0, 1);
              var blue = const Color.fromRGBO(0, 0, 255, 1);

              return Column(children: [
                Stack(
                  children: [
                    OrientationBuilder(builder: (context, orientation) {
                      return AspectRatio(
                          aspectRatio: orientation == Orientation.portrait
                              ? 1 / _controller.value.aspectRatio
                              : _controller.value.aspectRatio,
                          child: CameraPreview(_controller));
                    }),
                    boundingBoxToWidget(
                        personBoundingBox,
                        collidingWithLeftBottle || collidingWithRightBottle
                            ? red
                            : blue),
                    boundingBoxToWidget(leftBottleBoundingBox,
                        collidingWithLeftBottle ? red : blue),
                    boundingBoxToWidget(rightBottleBoundingBox,
                        collidingWithRightBottle ? red : blue),
                    Visibility(
                        visible: _startButtonVisible,
                        child: IconButton(
                            icon: const Icon(Icons.check_circle,
                                color: Color(0x0000FFc8)),
                            onPressed: () =>
                                setDrillStatus(DrillStatus.runningThere)))
                  ],
                )
              ]);
            }));

    // const AlertDialog(title: Text("Smashed it!"), content: Text("You sprinted X laps, for X seconds at a speed of X! "),)
  }

  @override
  void initState() {
    super.initState();
    initializeDrillStatusStateMachine();

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

  void initializeDrillStatusStateMachine() {
    for (DrillStatus drillStatus in DrillStatus.values) {
      var state = _drillStatusStateMachine.newState(drillStatus);
      if (drillStatus == DrillStatus.ready) {
        state.onEntry(() {
          _startButtonVisible = true;
        });
        state.onExit(() {
          _startButtonVisible = false;
        });
      } else if (drillStatus == DrillStatus.runningThere) {
        state.onEntry(() {
          if (_sprintLegs == 0) {
            _stopwatch.start();
          }
          // _goalCone = GoalCone.secondCone; TODO: uncomment
        });
      } else if (drillStatus == DrillStatus.runningBack) {
        state.onEntry(() {
          // _goalCone = GoalCone.firstCone; TODO: uncomment
        });
      } else if (drillStatus == DrillStatus.finished) {
        state.onEntry(() {
          _stopwatch.stop();
        });
      }

      setState(() {});
      // TODO: Add onEntry case for finished that stops timer
    }

    _drillStatusStateMachine.start();
    setDrillStatus(DrillStatus.notReady);
  }

  DrillStatus updateDrillStatus() {
    final drillStatus = getDrillStatus();

    switch (drillStatus) {
      case DrillStatus.notReady:
        // TODO: Check that the user has moved to the first cone
        setDrillStatus(DrillStatus.notReady);
        break;
      case DrillStatus.ready:
        // TODO: Wait for the user to click the button
        setDrillStatus(DrillStatus.ready);
        break;
      case DrillStatus.runningThere:
        // TODO: if the user intersects with the secondCone, change state to running back,
        //       increment the current lap count
        setDrillStatus(DrillStatus.runningThere);
        break;
      case DrillStatus.runningBack:
        // TODO: move to finished or running there based on lap count
        setDrillStatus(DrillStatus.runningBack);
        break;
      case DrillStatus.finished:
        break;
    }

    return getDrillStatus();
  }

  String getInstruction() {
    final drillStatus = getDrillStatus();

    switch (drillStatus) {
      case DrillStatus.notReady:
        return "Move to the first cone";
      case DrillStatus.ready:
        return "Press the button when you're ready to start";
      case DrillStatus.runningThere:
        return "Run to the first cone";
      case DrillStatus.runningBack:
        return "Run back";
      case DrillStatus.finished:
        return "";
    }
  }

  DrillStatus getDrillStatus() {
    return _drillStatusStateMachine.current!.identifier;
  }

  void setDrillStatus(DrillStatus drillStatus) {
    _drillStatusStateMachine.current = drillStatus;
    setState(() {});
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
