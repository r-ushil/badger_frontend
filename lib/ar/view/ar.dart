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
  noConesPlaced,
  oneConePlaced,
  twoConesPlaced,
  conesAreTooClose,
  conesAreTooFar,
  confirmCones,
  alignCones
}

class AR extends StatefulWidget {
  const AR({Key? key}) : super(key: key);

  @override
  State<AR> createState() => _ARState();
}

class _ARState extends State<AR> {
  static const idealConeDistance = 1;

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  state.Machine<UserState> userStateMachine = state.Machine<UserState>();

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
          builder: (context, orientation) => orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape(),
        ));
  }

  Widget buildPortrait() {
    return Column(children: [
      Expanded(
          child: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
      )),
      Text(getInstruction(userStateMachine)),
      Visibility(
          visible: confirmButtonVisibility,
          child: IconButton(
              onPressed: () async {
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
                ]);
                userStateMachine.current = UserState.alignCones;
              },
              icon: const Icon(
                Icons.check_circle,
                color: Color(0x0000FFc8),
              )))
    ]);
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager _) {
    initializeStates();
    initializeArManagers(
        arSessionManager, arObjectManager, arAnchorManager, onTap, onConeMoved);
  }

  onConeMoved(String nodeName) async {
    var userState = getCurrentUserState();

    if (userState == UserState.noConesPlaced ||
        userState == UserState.oneConePlaced) {
      return;
    }

    coneDistance = await getDistanceBetweenCones();

    if (coneDistance < idealConeDistance) {
      userStateMachine.current = UserState.conesAreTooClose;
    } else if (coneDistance > idealConeDistance) {
      userStateMachine.current = UserState.conesAreTooFar;
    } else {
      userStateMachine.current = UserState.confirmCones;
    }

    setState(() {});
  }

  UserState getCurrentUserState() {
    return userStateMachine.current!.identifier;
  }

  Future<double> getDistanceBetweenCones() async {
    return round1((await arSessionManager.getDistanceBetweenAnchors(
        cone1Anchor!, cone2Anchor!))!);
  }

  Widget buildLandscape() {
    return buildPortrait();
  }

  String getInstruction(state.Machine<UserState> stateMachine) {
    if (stateMachine.current == null) {
      return "";
    }

    var userState = getCurrentUserState();

    if (userState == UserState.noConesPlaced) {
      return "Place your first cone down";
    } else if (userState == UserState.oneConePlaced) {
      return "Place your second cone down";
    } else if (userState == UserState.conesAreTooFar) {
      return "Move cones closer";
    } else if (userState == UserState.conesAreTooClose) {
      return "Move cones further away";
    } else {
      return "Done";
    }
  }

  void initializeStates() {
    for (UserState userState in UserState.values) {
      var state = userStateMachine.newState(userState);
      if (userState == UserState.confirmCones) {
        state.onEntry(() {
          confirmButtonVisibility = true;
          setState(() {});
        });
        state.onExit(() {
          confirmButtonVisibility = false;
          setState(() {});
        });
      }
    }

    userStateMachine.start();
    setState(() {});
  }

  void initializeArManagers(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      Future<void> Function(List<ARHitTestResult>) onTap,
      dynamic Function(String) onConeMoved) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this
        .arSessionManager
        .onInitialize(handlePans: true, showAnimatedGuide: false);
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onTap;
    this.arObjectManager.onPanChange = onConeMoved;
  }

  Future<void> onTap(List<ARHitTestResult> results) async {
    var userState = getCurrentUserState();

    if (!(userState == UserState.noConesPlaced ||
        userState == UserState.oneConePlaced)) {
      return;
    }

    ARHitTestResult planeHit =
        results.firstWhere((r) => r.type == ARHitTestResultType.plane);

    var planeHitAnchor = await constructAnchorFromPlaneHit(planeHit);
    var planeHitNode = await addNodeToAnchor(planeHitAnchor);

    if (userState == UserState.noConesPlaced) {
      cone1Anchor = planeHitAnchor;
      cone1Node = planeHitNode;
      userStateMachine.current = UserState.oneConePlaced;
      setState(() {});
    } else {
      cone2Anchor = planeHitAnchor;
      cone2Node = planeHitNode;

      coneDistance = await getDistanceBetweenCones();

      if (coneDistance < idealConeDistance) {
        userStateMachine.current = UserState.conesAreTooClose;
      } else if (coneDistance > idealConeDistance) {
        userStateMachine.current = UserState.conesAreTooFar;
      } else {
        userStateMachine.current = UserState.confirmCones;
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }

      setState(() {});
    }
  }

  Future<ARPlaneAnchor> constructAnchorFromPlaneHit(
      ARHitTestResult planeHit) async {
    assert(planeHit.type == ARHitTestResultType.plane);
    var planeHitAnchor = ARPlaneAnchor(transformation: planeHit.worldTransform);
    var anchorAdded = await arAnchorManager.addAnchor(planeHitAnchor);
    assert(anchorAdded != null && anchorAdded);

    return planeHitAnchor;
  }

  Future<ARNode> addNodeToAnchor(ARPlaneAnchor planeHitAnchor) async {
    var planeHitNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0, 0, 0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));

    var nodeAdded = await arObjectManager.addNode(planeHitNode,
        planeAnchor: planeHitAnchor);
    assert(nodeAdded != null && nodeAdded);

    return planeHitNode;
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

  // Static methods
  static double round1(double x) {
    return double.parse(x.toStringAsFixed(1));
  }
}
