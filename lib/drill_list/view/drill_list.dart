import 'package:badger_frontend/drill_list/view-model/drill_view_model.dart';
import 'package:badger_frontend/drill_list/view/widgets/drill_card.dart';
import 'package:flutter/material.dart';

class DrillList extends StatelessWidget {
  const DrillList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrillViewModel drillViewModel = DrillViewModel();
    final List<DrillData> drillData = drillViewModel.getDrillData();

    return Stack(alignment: Alignment.topLeft, children: [
      Expanded(
          child: ListView.builder(
              itemCount: drillData.length,
              itemBuilder: (BuildContext context, int index) {
                return DrillCard(drill: drillData[index]);
              })),
      Material(
          color: Colors.black,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ))
    ]);
  }
}
