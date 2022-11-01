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

class AR extends StatefulWidget {
  const AR({Key? key}) : super(key: key);

  @override
  State<AR> createState() => _ARState();
}

class _ARState extends State<AR> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;

  double coneDistance = 0;

  ARNode? cone1Node;
  ARAnchor? cone1Anchor;
  ARNode? cone2Node;
  ARAnchor? cone2Anchor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(coneDistance.toString())),
        body: Column(
          children: [
            Expanded(
                child: ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig: PlaneDetectionConfig.horizontal,
                )
            ),
            Text("hello")
          ]
        )
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager, ARObjectManager arObjectManager, ARAnchorManager arAnchorManager, ARLocationManager arLocationManager) {
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

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> results) async {
    if (cone1Anchor != null && cone2Anchor != null) {
      return;
    }
    ARHitTestResult result = results.firstWhere((r) => r.type == ARHitTestResultType.plane);
    var anchor = ARPlaneAnchor(transformation: result.worldTransform);
    var added = await arAnchorManager.addAnchor(anchor);
    if (added == null || added == false) {
      return;
    }
    if (cone1Anchor == null) {
      cone1Anchor = anchor;
    } else {
      cone2Anchor = anchor;
    }

    var node = ARNode(
        type: NodeType.webGLB,
        uri:
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0));
    added = await arObjectManager.addNode(node, planeAnchor: anchor);
    if (added == null || added == false) {
      return;
    }
    if (cone1Node == null) {
      cone1Node = node;
    } else {
      cone2Node = node;
    }

  }

  onPanChanged(String nodeName) async {
    if (cone1Anchor == null || cone2Anchor == null) {
      return;
    }
    coneDistance = (await arSessionManager.getDistanceBetweenAnchors(cone1Anchor!, cone2Anchor!))!;
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }
}