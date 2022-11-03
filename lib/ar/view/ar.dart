import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:statemachine/statemachine.dart' as state;
import 'package:flutter/services.dart';

enum UserState {
  start,
  oneCone,
  twoCones,
  tooClose,
  tooFar,
  confirmCones,
  alignCones
}

class AR extends StatefulWidget {
  const AR({Key? key}) : super(key: key);

  @override
  State<AR> createState() => _ARState();
}

class _ARState extends State<AR> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  state.Machine<UserState> userState = state.Machine<UserState>();

  double coneDistance = 0;

  ARNode? cone1Node;
  ARAnchor? cone1Anchor;
  ARNode? cone2Node;
  ARAnchor? cone2Anchor;

  bool confirmButtonVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(coneDistance.toString())),
        body: OrientationBuilder(
          builder: (context, orientation)
          => orientation == Orientation.portrait ? buildPortrait()
                                                 : buildLandscape(),
        )
    );
  }

  Widget buildPortrait() {
    return Column(
        children: [
          Expanded(
              child: ARView(
                onARViewCreated: onARViewCreated,
                planeDetectionConfig: PlaneDetectionConfig.horizontal,
              )
          ),
          Text(getInstruction(userState)),
          Visibility(
            visible: confirmButtonVisibility,
              child: IconButton(onPressed: () async {
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
                ]);
                userState.current = UserState.alignCones;

              }, icon: const Icon(Icons.check_circle, color: Color(0x0000FFc8),))
          )
        ]
    );
  }

  Widget buildLandscape() {
    return buildPortrait();
  }

  String getInstruction(state.Machine<UserState> machine) {
    if (machine.current == null) {
      return "";
    }

    var uState = machine.current?.identifier;

    if (uState == UserState.start) {
      return "Place your first cone down";
    } else if (uState == UserState.oneCone) {
      return "Place your second cone down";
    } else if (uState  == UserState.tooFar) {
      return "Move cones closer";
    } else if (uState == UserState.tooClose){
      return "Move cones further away";
    } else {
      return "Done";
    }
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
    for (UserState uState in UserState.values) {
      var s = userState.newState(uState);
      if (uState == UserState.confirmCones) {
        s.onEntry(() {
          confirmButtonVisibility = true;
          setState(() {});
        });
        s.onExit(() {
          confirmButtonVisibility = false;
          setState(() {});
        });
      }
    }
    userState.start();
    setState(() {});
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
      handlePans: true,
      showAnimatedGuide: false
    );
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onPanChange = onPanChanged;
  }

  double round1(double x) {
    return double.parse(x.toStringAsFixed(1));
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> results) async {
    var uState = userState.current?.identifier;

    if (!(uState == UserState.start || uState == UserState.oneCone)) {
      return;
    }
    ARHitTestResult result = results.firstWhere((r) => r.type == ARHitTestResultType.plane);
    var anchor = ARPlaneAnchor(transformation: result.worldTransform);
    var added = await arAnchorManager.addAnchor(anchor);
    if (added == null || added == false) {
      return;
    }

    var node = ARNode(
        type: NodeType.webGLB,
        uri:
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0, 0, 0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));
    added = await arObjectManager.addNode(node, planeAnchor: anchor);
    if (added == null || added == false) {
      return;
    }
    if (uState == UserState.start) {
      cone1Anchor = anchor;
      cone1Node = node;
      userState.current = UserState.oneCone;
      setState(() {});
    } else {
      cone2Anchor = anchor;
      cone2Node = node;
      coneDistance = round1((await arSessionManager.getDistanceBetweenAnchors(cone1Anchor!, cone2Anchor!))!);
      if (coneDistance < 1.0) {
        userState.current = UserState.tooClose;
      }  else if (coneDistance > 1.0)  {
        userState.current = UserState.tooFar;
      } else {
        userState.current = UserState.confirmCones;
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);

      }

      setState(() {});
    }
  }

  onPanChanged(String nodeName) async {
    var uState = userState.current?.identifier;
    if (uState == UserState.start || uState == UserState.oneCone) {
      return;
    }
    coneDistance = round1((await arSessionManager.getDistanceBetweenAnchors(cone1Anchor!, cone2Anchor!))!);
    if (coneDistance < 1) {
      userState.current = UserState.tooClose;
    } else if (coneDistance > 1) {
      userState.current = UserState.tooFar;
    } else {
      userState.current = UserState.confirmCones;
    }
    setState(() {});
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    arSessionManager.dispose();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}