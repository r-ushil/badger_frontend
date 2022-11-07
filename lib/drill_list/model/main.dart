import "package:badger_frontend/drill_list/model/drill_model.dart";

void main() async {
  print("here0");
  final instrs = await DrillModel.getDrillData("6352414e50c7d61db5d52861");
  print("returned");
}
