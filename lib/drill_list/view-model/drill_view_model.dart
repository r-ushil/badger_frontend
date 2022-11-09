import 'package:badger_frontend/drill_list/model/drill_model.dart';
import 'package:flutter/material.dart';

class DisplayableDrill {
  //todo - replace with builder pattern for better readability
  DisplayableDrill(
      this.name, this.skills, this.thumbnailUrl, this.videoUrl, this.description);

  final String name;
  final List<Icon> skills;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;
}

// create drill view model
class DrillViewModel {
  static Future<List<DisplayableDrill>> getDisplayableDrills() async {
    List<DisplayableDrill> displayableDrills = List.empty(growable: true);
    var drills = await DrillModel.getDrillsData();
    for (var drill in drills) {
      displayableDrills.add(DisplayableDrill(
          drill.drillName,
          matchIcons(drill.skills),
          drill.thumbnailUrl,
          drill.videoUrl,
          drill.drillDescription));
    }
    return displayableDrills;
  }

  static List<Icon> matchIcons(List<String> skills) {
    //TODO: implement
    return List.empty();
  }
}
