import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import '../../cone_drill_mobile_net/view/cone_drill_mobilenet.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            MetricChart(),
            MetricProgressBars(),
          ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          List<CameraDescription> cameras = await availableCameras();
          // await Tflite.loadModel(
          //     model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
          // print("loaded");
          await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt",
          ).then((_) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConeDrillMobilenet(cameras: cameras)));
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //bottomNavigationBar: const BottomTabBar(),
    );
  }
}
