import 'package:badger_frontend/record_video/view/widgets/camera.dart';
import 'package:badger_frontend/record_video/view_model/record_video_view_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key, required this.camera, required this.drillId});
  final CameraDescription camera;
  final String drillId;

  @override
  State<RecordVideo> createState() => _RecordVideo();
}

class _RecordVideo extends State<RecordVideo> {
  @override
  Widget build(BuildContext context) {
    Provider.of<RecordVideoViewModel>(context).setDrillId(widget.drillId);
    return Camera(camera: widget.camera);
  }
}
