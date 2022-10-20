import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RecordingPreview extends StatefulWidget {
  const RecordingPreview({super.key});
  @override
  State<RecordingPreview> createState() => _RecordingPreviewState();
}

class _RecordingPreviewState extends State<RecordingPreview> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late String videoPath;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      videoPath = (ModalRoute.of(context)!.settings.arguments as List)[0];
      _controller = VideoPlayerController.file(File(videoPath));
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.setLooping(true);
    });
    _controller = VideoPlayerController.file(File(""));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
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
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              Container(
                  padding: const EdgeInsets.all(32),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      // If the video is playing, pause it.
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                  ),
                  iconSize: 60,
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    String path =
                        "videos/${DateTime.now().millisecondsSinceEpoch.toString()}.mp4";
                    FirebaseStorage.instance
                        .ref()
                        .child(path)
                        .putFile(File(videoPath));
                    FirebaseFirestore.instance.collection('drills').add({
                      'name': (ModalRoute.of(context)!.settings.arguments
                          as List)[1],
                      'score': Random().nextInt(10),
                      'timestamp': Timestamp.now(),
                      'video': path
                    });
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Center(child: Text("Saved!")),
                              actions: [
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close),
                                  color: Colors.red,
                                )
                              ],
                            ));
                  },
                  icon: const Icon(Icons.save),
                  iconSize: 60,
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  icon: const Icon(Icons.home),
                  color: Colors.red,
                  iconSize: 60,
                )
              ])
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
