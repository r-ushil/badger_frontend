import 'package:badger_frontend/api_models/drill_model.dart';

void main() async {
  print("start");
  var drills = await DrillModel.getDrillsData();
  for (var drill in drills) {
    print(drill.drillName);
  }
  print("done");
}
