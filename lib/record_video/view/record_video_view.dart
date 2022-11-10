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
  bool _isRecording = false;

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
            return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: _isRecording ? 3 : 0, color: Colors.red)),
                child: Stack(
                  children: [
                    Expanded(child: _controller.buildPreview()),
                    InkWell(
                        onTap: () async {
                          _isRecording = !_isRecording;
                          setState(() {});
                          // if (_isRecording) {
                          //   var xFileVideo = await _controller!.stopVideoRecording();
                          //   _isRecording = false;
                          //   setState(() {});
                          //   var videoFile = File(xFileVideo.path);
                          // } else {
                          //   await _controller.stopVideoRecording();
                          //   _isRecording = true;
                          //   setState(() {});
                          // }
                          // setState(() {});
                        },
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              Icon(Icons.circle,
                                  color: _isRecording
                                      ? Colors.white
                                      : Colors.white38,
                                  size: 80),
                              Icon(Icons.circle,
                                  color:
                                      _isRecording ? Colors.red : Colors.white,
                                  size: 65),
                            ])))
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
