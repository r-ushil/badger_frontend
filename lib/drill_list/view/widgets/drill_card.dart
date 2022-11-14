import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:badger_frontend/record_video/view/record_video_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DrillCard extends StatelessWidget {
  final DisplayableDrill drill;

  const DrillCard({Key? key, required this.drill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0x00121212),
        child: GFListTile(
          //TODO: change on tap to navigate to correct screen depending on drill
          onTap: () async {
            await availableCameras().then((cameras) async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecordVideo(camera: cameras[0])));
            });
          },
          color: const Color(0x00262627),
          titleText: drill.name,
          description: Text(drill.description,
              style: const TextStyle(fontSize: 12, color: Colors.deepOrange)),
          avatar: SizedBox(
              height: 100,
              width: 100,
              child: Image.network(drill.thumbnailUrl)),
          icon: drill.skills[0],
          padding: const EdgeInsets.all(4.0),
        ));
  }
}
