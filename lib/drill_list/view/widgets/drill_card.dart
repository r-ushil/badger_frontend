import 'package:badger_frontend/ar/view/ar.dart';
import 'package:badger_frontend/drill_list/view-model/drill_view_model.dart';
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
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AR())),
          color: const Color(0x00262627),
          titleText: drill.name,
          description:
              Text(drill.description, style: const TextStyle(fontSize: 12)),
          avatar: SizedBox(height: 100, width: 100, child: Image.network(drill.thumbnailUrl)),
          icon: drill.skill,
          padding: const EdgeInsets.all(4.0),
        ));
  }
}
