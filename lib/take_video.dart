import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

class TakeVideo extends StatefulWidget {
  const TakeVideo({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakeVideoState createState() => TakeVideoState();
}

class TakeVideoState extends State<TakeVideo> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _recording = false;

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
      appBar: AppBar(
        title: const Text('Badger'),
        backgroundColor: Colors.red[200],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Container(
                  padding: const EdgeInsets.all(32),
                  child: CameraPreview(_controller)),
              IconButton(
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    if (!_recording) {
                      await _controller.startVideoRecording();
                      setState(() {
                        _recording = !_recording;
                      });
                    } else {
                      final video = await _controller.stopVideoRecording();
                      setState(() {
                        _recording = !_recording;
                      });
                      Navigator.pushNamed(context, '/recordingPreview',
                          arguments: [
                            video.path,
                            ModalRoute.of(context)!.settings.arguments as String
                          ]);
                    }

                    //if (!mounted) return;
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                icon: _recording
                    ? const Icon(Icons.pause_circle_filled)
                    : const Icon(Icons.play_circle_filled),
                color: Colors.red,
                iconSize: 60,
              )
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
