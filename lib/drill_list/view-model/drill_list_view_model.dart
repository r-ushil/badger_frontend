import 'package:badger_frontend/api_models/drill_model.dart';

class DisplayableDrill {
  //todo - replace with builder pattern for better readability
  DisplayableDrill(this.drillId, this.name, this.skills, this.thumbnailUrl, this.videoUrl,
      this.description, this.duration);

  final String drillId;
  final String name;
  final List<String> skills;
  final String thumbnailUrl;
  final String videoUrl;
  final String description;
  final int duration;
}

// create drill view model
class DrillListViewModel {
  static Future<List<DisplayableDrill>> getDisplayableDrills() async {
    List<DisplayableDrill> displayableDrills = List.empty(growable: true);
    var drills = await DrillModel.getDrillsData();
    for (var drill in drills) {
      displayableDrills.add(DisplayableDrill(
          drill.drillId,
          drill.drillName,
          drill.skills,
          drill.thumbnailUrl,
          drill.videoUrl,
          drill.drillDescription,
          drill.duration));
    }
    return displayableDrills;
  }
}
