import 'package:badger_frontend/api_models/drill_model.dart';
import 'package:flutter/material.dart';

class DisplayableDrill {
  //todo - replace with builder pattern for better readability
  DisplayableDrill(this.name, this.skills, this.thumbnailUrl, this.videoUrl,
      this.description);

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
    return skills.map((skill) {
      switch (skill) {
        case "reaction_time":
          return const Icon(
            Icons.flash_on,
            color: Colors.lightBlue,
          );
        case "power":
          return const Icon(Icons.local_fire_department,
              color: Colors.lightBlue);
        case "timing":
          return const Icon(Icons.timer, color: Colors.lightBlue);
        case "agility":
          return const Icon(Icons.directions_run, color: Colors.lightBlue);
        case "hand_speed":
          return const Icon(Icons.speed, color: Colors.lightBlue);
        default:
          return const Icon(Icons.error, color: Colors.lightBlue);
      }
    }).toList();
  }
}
