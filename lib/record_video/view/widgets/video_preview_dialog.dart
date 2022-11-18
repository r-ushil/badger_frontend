import 'dart:io';
import 'package:badger_frontend/record_video/view/widgets/video_player_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../../../drill_evaluation/view/drill_evaluation.dart';
import '../../view_model/record_video_view_model.dart';

class VideoPreviewDialog extends StatefulWidget {
  const VideoPreviewDialog({super.key, required this.videoFile});
  final File videoFile;
  @override
  State<VideoPreviewDialog> createState() => _VideoPreviewDialog();
}

class _VideoPreviewDialog extends State<VideoPreviewDialog> {
  late Future<void> _previewInitialisationFuture;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(widget.videoFile);
    _videoController.setLooping(true);
    _previewInitialisationFuture = _videoController.initialize();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<RecordVideoViewModel>(context);
    viewModel.setVideoPlayerController(_videoController);
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
        TextButton(
            onPressed: () async {
              viewModel.uploadVideo().then((submissionId) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrillEvaluation(
                            drillSubmissionId: submissionId,
                          ))));
            },
            child: const Text("CONFIRM", style: TextStyle(color: Colors.grey)))
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          side: BorderSide(color: Colors.green, width: 2)),
      backgroundColor: Colors.black,
      title: const Center(
          child: Text(
        "Confirm Submission?",
        textAlign: TextAlign.center,
      )),
      titleTextStyle: const TextStyle(color: Colors.grey, fontSize: 30),
      content: Scaffold(
          body: Center(
              child: FutureBuilder(
            future: _previewInitialisationFuture,
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.done
                ? Center(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                    VideoPlayer(viewModel.videoController),
                    VideoProgressIndicator(
                      viewModel.videoController,
                      allowScrubbing: true,
                      colors:
                          const VideoProgressColors(playedColor: Colors.green),
                    )
                  ]))
                : const Center(child: CircularProgressIndicator()),
          )),
          floatingActionButton: const VideoPlayerButton()),
    );
  }
}
