import 'package:badger_frontend/drill_list/view-model/drill_view_model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DrillCard extends StatelessWidget {
  final DrillData drill;

  const DrillCard({Key? key, required this.drill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0x00121212),
        child: GFListTile(
          color: const Color(0x00262627),
          subTitle: Text("${drill.timeTaken} minutes",
              style: const TextStyle(fontSize: 12)),
          titleText: drill.name,
          description:
              Text(drill.description, style: const TextStyle(fontSize: 12)),
          avatar: SizedBox(height: 100, width: 100, child: drill.thumbnail),
          icon: drill.skill,
          padding: const EdgeInsets.all(4.0),
        ));
  }
}
