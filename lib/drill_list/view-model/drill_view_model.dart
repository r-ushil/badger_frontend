import 'package:badger_frontend/drill_list/model/drill_model.dart';
import 'package:flutter/material.dart';

class DisplayableDrill {
  //todo - replace with builder pattern for better readability
  DisplayableDrill(
      this.name, this.thumbnailUrl, this.mediaUrl, this.description);

  final String name;
  final String thumbnailUrl;
  final String mediaUrl;
  final String description;
}

// create drill view model
class DrillViewModel {
  static Future<List<DisplayableDrill>> getDrillsData() async {
    List<DisplayableDrill> displayableDrills = List.empty(growable: true);
    var drills = await DrillModel.getDrillsData();
    for (var drill in drills) {
      var instrs = await DrillModel.getDrillInstructionData(drill.drillId);
      displayableDrills.add(DisplayableDrill(
          drill.drillName,
          //TODO: correct for thumbnail/media urls?
          instrs.steps.first.mediaUrl,
          instrs.steps.first.mediaUrl,
          drill.drillDescription));
    }
    return displayableDrills;

    // to replace with api call handling
    // return [
    //   DrillData(
    //       "Sprint",
    //       const Icon(Icons.flash_on),
    //       1,
    //       Image.network(
    //           "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg"),
    //       "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    //       "Sprint back and forth between two cones 5 times as quickly as you can!"),
    //   DrillData(
    //       "Sprint",
    //       const Icon(Icons.flash_on),
    //       1,
    //       Image.network(
    //           "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg"),
    //       "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    //       "Sprint back and forth between two cones 5 times as quickly as you can!"),
    //   DrillData(
    //       "Sprint",
    //       const Icon(Icons.flash_on),
    //       1,
    //       Image.network(
    //           "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg"),
    //       "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    //       "Sprint back and forth between two cones 5 times as quickly as you can!"),
    // ];
  }
}
