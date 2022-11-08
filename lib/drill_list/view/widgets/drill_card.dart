import 'package:badger_frontend/drill_list/view-model/drill_list_view_model.dart';
import 'package:badger_frontend/record_video/view/record_video_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class DrillCard extends StatelessWidget {
  final DisplayableDrill drill;

  const DrillCard({Key? key, required this.drill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DrillViewModel>(context);

    return Material(
        color: const Color(0x00121212),
        child: GFListTile(
          //TODO: change on tap to navigate to correct screen depending on drill
          onTap: () {},
          color: const Color(0xff262627),
          subTitle: const Text("fix me minutes",
              style: TextStyle(fontSize: 12)),
          title: Text(drill.name, style: const TextStyle(fontSize: 16, color: Colors.white)),
          description: Column(
            children: [
              Row(
                children: [
                  drill.skills[0],
                  const Text(
                    "fix me",
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Text(drill.description, style: const TextStyle(fontSize: 12)),
            ],
          ),
          avatar: SizedBox(height: 100, width: 150, child: Image.network(drill.thumbnailUrl)),
          padding: const EdgeInsets.all(4.0),
        ));
  }
}
