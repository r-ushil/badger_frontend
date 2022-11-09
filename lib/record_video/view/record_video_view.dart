import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;

  @override
  State<RecordVideo> createState() => _RecordVideo();
}

class _RecordVideo extends State<RecordVideo> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(32),
                      child: CameraPreview(_controller)))
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
