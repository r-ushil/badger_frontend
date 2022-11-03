import 'package:badger_frontend/ar/view/ar.dart';
import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import '../../cone_drill/view/cone_drill.dart';

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
          await Tflite.loadModel(
              model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
          print("loaded");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ConeDrill(cameras: cameras)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //bottomNavigationBar: const BottomTabBar(),
    );
  }
}
