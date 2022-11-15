import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/record_video_view_model.dart';

class VideoPlayerButton extends StatelessWidget {
  const VideoPlayerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<RecordVideoViewModel>(context);
    return Container(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            viewModel.isPlayingPreview()
                ? viewModel.pausePreview()
                : viewModel.playPreview();
          },
          backgroundColor: Colors.green,
          child: Icon(
            viewModel.isPlayingPreview() ? Icons.pause : Icons.play_arrow,
          ),
        ));
  }
}
