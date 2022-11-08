import "package:badger_frontend/drill_list/model/drill_model.dart";

void main() async {
  print("here0");
  final instrs = await DrillModel.getDrillsData();
  print("returned");
}
