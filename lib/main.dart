import 'package:badger_frontend/initial_dev/drill_instructions.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:badger_frontend/initial_dev/performance_overview.dart';
import 'package:badger_frontend/initial_dev/home.dart';
import 'package:badger_frontend/initial_dev/take_video.dart';
import 'package:badger_frontend/initial_dev/recording_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  await Firebase.initializeApp();

  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/performanceOverview': (context) => const PerformanceOverview(),
        '/drillInstructions': (context) => const DrillInstructions(),
        '/takeVideo': (context) => TakeVideo(
              camera: camera,
            ),
        '/recordingPreview': (context) => const RecordingPreview(),
      },
    );
  }
}
