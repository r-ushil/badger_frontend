import 'dart:io';

import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../../api_models/drill_submission_model.dart';
import '../../../drill_evaluation/view/drill_evaluation.dart';
import 'metric_card.dart';

class DrillCard extends StatelessWidget {
  final DisplayableDrill drill;

  const DrillCard({Key? key, required this.drill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // await availableCameras().then((cameras) async {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => RecordVideo(
          //               camera: cameras[0], drillId: drill.drillId)));
          // });
          showVideoSourceDialog(context, drillName: drill.name);
        },
        child: Material(
            color: const Color(0xff262627),
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  title: Text(drill.name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  leading: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        drill.thumbnailUrl,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                                child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                        color: Colors.white)));
                          }
                        },
                      )),
                  subtitle: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${drill.duration} minutes",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          )),
                    ],
                  ),
                  children: <Widget>[
                    ListTile(
                        subtitle: Text(
                      drill.description,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ))
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var index = 0;
                                    index < drill.skills.length;
                                    index++)
                                  Row(
                                    children: [
                                      MetricCard(
                                          metricName: drill.skills[index]),
                                      const SizedBox(width: 5)
                                    ],
                                  )
                              ],
                            )))),
              ],
            )));
  }
}

showVideoSourceDialog(BuildContext context, {required String drillName}) {
  ImagePicker videoPicker = ImagePicker();
  File? videoFile;

  // set up the buttons
  Widget cameraButton = TextButton(
    child: const Text("Camera", style: TextStyle(color: Colors.blue)),
    onPressed: () async {
      final source = await videoPicker.getVideo(source: ImageSource.camera);
      videoFile = File(source!.path);
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayVideo(
                data: videoFile!,
                drillName: drillName,
              )));
    },
  );
  Widget galleryButton = TextButton(
    child: const Text("Gallery", style: TextStyle(color: Colors.blue)),
    onPressed: () async {
      final source = await videoPicker.getVideo(source: ImageSource.gallery);
      videoFile = File(source!.path);
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlayVideo(
                data: videoFile!,
                drillName: drillName,
              )));
    },
  );
  Widget backButton = TextButton(
    child: const Text("Back", style: TextStyle(color: Colors.blue)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Select Video Source"),
    content: const Text("Please select a video source for your chosen drill."),
    actions: [
      cameraButton,
      galleryButton,
      backButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class PlayVideo extends StatefulWidget {
  final File data;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final String drillName;

  PlayVideo({Key? key, required this.data, required this.drillName}) : super(key: key);
  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.data)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> uploadVideo() async {
    final String videoUuid = const Uuid().v4();
    final String videoObjName = "videos/$videoUuid.mp4";

    Reference ref = FirebaseStorage.instance.ref().child(videoObjName);
    await ref.putFile(widget.data).whenComplete(() => null);

    return await DrillSubmissionModel.submitDrill(
        widget.userId, widget.drillName, videoObjName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
            // row of elevated buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                uploadVideo()
                    .then((submissionId) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DrillEvaluation(
                                  drillSubmissionId: submissionId,
                                ))));
              },
              child: const Text('Submit'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ]),
    ));
  }
}
