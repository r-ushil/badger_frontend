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
    final metricList = drill.skills;

    return InkWell(
        onTap: () async {
          await availableCameras().then((cameras) async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecordVideo(camera: cameras[0])));
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
                  //TODO: change on tap to navigate to correct screen depending on drill
                  //onTap: () => Navigator.push(
                  //    context, MaterialPageRoute(builder: (context) => const AR())),
                  //tileColor: const Color(0xff262627),
                  title: Text(drill.name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  leading: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minHeight: 300, maxHeight: 300),
                      child: Image.network(drill.thumbnailUrl)),
                  subtitle: Column(
                    children: const [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "fix me minutes",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )),
                      /*Text(
                    drill.description,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.justify,
                  ),*/
                    ],
                  ),
                  //contentPadding: const EdgeInsets.all(4.0),
                  //visualDensity:
                  //    const VisualDensity(vertical: VisualDensity.maximumDensity),
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
                                    index < metricList.length;
                                    index++)
                                  Row(
                                    children: const [
                                      MetricCard(metricName: "Power"),
                                      SizedBox(width: 5)
                                    ],
                                  )
                              ],
                            )))),
              ],
            )));
  }
}
