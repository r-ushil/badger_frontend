import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../record_video/view/record_video_view.dart';
import 'metric_card.dart';

class DrillCard extends StatelessWidget {
  final DisplayableDrill drill;

  const DrillCard({Key? key, required this.drill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await availableCameras().then((cameras) async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecordVideo(
                        camera: cameras[0], drillId: drill.drillId)));
          });
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
