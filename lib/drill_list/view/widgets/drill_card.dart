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
        child: ListTile(
          //TODO: change on tap to navigate to correct screen depending on drill
          onTap: () {},
          tileColor: const Color(0xff262627),
          title: Text(drill.name.toUpperCase(),
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          leading: ConstrainedBox(constraints: const BoxConstraints(minHeight: 300, maxHeight: 300),
              child: Image.network(drill.thumbnailUrl)),
          subtitle: Column(
          children: [
            const Align(alignment: Alignment.topLeft, child: Text(" fix me minutes", style: TextStyle(fontSize: 12, color: Colors.white),)),
            Text(drill.description, style: const TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.justify,),
          ],
        ),
            trailing: Container(
              width: 80,
              height: 25,
              padding: const EdgeInsets.only(left: 2.0),
              decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    children: [
                      drill.skills[0],
                      const Text(
                        "fix me",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          contentPadding: const EdgeInsets.all(4.0),
          shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(5))
        ));
  }
}
