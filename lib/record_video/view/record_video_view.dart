import 'package:badger_frontend/record_video/view/widgets/camera.dart';
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
  @override
  Widget build(BuildContext context) {
    return Camera(camera: widget.camera);
  }
}
