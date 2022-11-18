import 'dart:io';

import 'package:badger_frontend/api_models/drill_submission_model.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class RecordVideoViewModel with ChangeNotifier {
  late CameraController _controller;
  bool _isRecording = false;
  late File _videoFile;
  late VideoPlayerController _videoController;
  String drillId = "";

  CameraController get cameraController => _controller;
  get isRecording => _isRecording;

  File get videoFile => _videoFile;

  VideoPlayerController get videoController => _videoController;

  void setCameraController(CameraController controller) {
    _controller = controller;
  }

  Future<void> stopRecording() async {
    var xFileVideo = await _controller.stopVideoRecording();
    _isRecording = false;
    _videoFile = File(xFileVideo.path);
    notifyListeners();
  }

  Future<void> startRecording() async {
    await _controller.startVideoRecording();
    _isRecording = true;
    notifyListeners();
  }

  Future<String> uploadVideo() async {
    Reference ref = FirebaseStorage.instance.ref().child(
        "videos/${DateTime.now().millisecondsSinceEpoch.toString()}.mp4");
    UploadTask task = ref.putFile(_videoFile);
    await task.whenComplete(() {});
    String bucketUrl = await ref.getDownloadURL();
    return await DrillSubmissionModel.submitDrill(
        "todo: auth", drillId, bucketUrl);
  }

  void setVideoPlayerController(VideoPlayerController controller) {
    _videoController = controller;
  }

  bool isPlayingPreview() {
    return _videoController.value.isPlaying;
  }

  void pausePreview() {
    _videoController.pause();
    notifyListeners();
  }

  void playPreview() {
    _videoController.play();
    notifyListeners();
  }

  void setDrillId(String drillId) {
    this.drillId = drillId;
  }
}
