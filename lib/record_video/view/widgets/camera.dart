import 'package:badger_frontend/record_video/view/widgets/camera_capture_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/record_video_view_model.dart';

class Camera extends StatefulWidget {
  const Camera({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;

  @override
  State<Camera> createState() => _Camera();
}

class _Camera extends State<Camera> {
  late Future<void> _initializeControllerFuture;
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecordVideoViewModel>(context);
    viewModel.setCameraController(_controller);

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: viewModel.isRecording ? 3 : 0,
                        color: Colors.red)),
                child: Stack(
                  children: [
                    Expanded(child: viewModel.cameraController.buildPreview()),
                    const CameraCaptureButton()
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
