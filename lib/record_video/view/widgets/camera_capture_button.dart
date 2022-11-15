import 'package:badger_frontend/record_video/view/widgets/video_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/record_video_view_model.dart';

class CameraCaptureButton extends StatelessWidget {
  const CameraCaptureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<RecordVideoViewModel>(context);
    return InkWell(
        onTap: () async {
          if (viewModel.isRecording) {
            await viewModel.stopRecording();
            showDialog(
                context: context,
                builder: (context) =>
                    VideoPreviewDialog(videoFile: viewModel.videoFile));
          } else {
            viewModel.startRecording();
          }
        },
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(alignment: Alignment.center, children: [
              Icon(Icons.circle,
                  color: viewModel.isRecording ? Colors.white : Colors.white38,
                  size: 80),
              Icon(Icons.circle,
                  color: viewModel.isRecording ? Colors.red : Colors.white,
                  size: 65),
            ])));
  }
}
