import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class RecordVideoViewModel with ChangeNotifier {
  late CameraController _controller;
  bool _isRecording = false;
  late File _videoFile;
  late VideoPlayerController _videoController;

  get cameraController => _controller;
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

  void uploadVideo() {
    FirebaseStorage.instance
        .ref()
        .child("videos/${DateTime.now().millisecondsSinceEpoch.toString()}.mp4")
        .putFile(_videoFile);
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
}
