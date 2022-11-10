import 'package:badger_frontend/badger-api/drill/v1/drill_api.pbgrpc.dart';
import 'package:badger_frontend/drill_list/model/api_client_channel.dart';
import 'package:grpc/grpc.dart';

//classes directly representing backend implementations
class DrillData {
  final String drillId;
  final String drillName;
  final String drillDescription;
  final String instructions;
  final String thumbnailUrl;
  final List<String> skills;
  final String videoUrl;

  DrillData(this.drillId, this.drillName, this.drillDescription,
      this.instructions, this.thumbnailUrl, this.skills, this.videoUrl);
}

class DrillModel {
  static final drillServiceClient = DrillServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static Future<List<DrillData>> getDrillsData() async {
    List<DrillData> drills = List.empty(growable: false);
    final req = GetDrillsRequest();
    try {
      final res = await drillServiceClient.getDrills(req);
      drills = res.drills
          .map((drill) => DrillData(
              drill.drillId,
              drill.drillName,
              drill.drillDescription,
              drill.instructions,
              drill.thumbnailUrl,
              drill.skills,
              drill.videoUrl))
          .toList();
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drills;
  }

  static Future<DrillData> getDrillData(String drillId) async {
    final req = GetDrillRequest(drillId: drillId);
    DrillData drill = DrillData(
        "0", "dummy", "dummy", "dummy", "dummy", List.empty(), "dummy");
    try {
      final res = await drillServiceClient.getDrill(req);
      drill = DrillData(
          res.drill.drillId,
          res.drill.drillName,
          res.drill.drillDescription,
          res.drill.instructions,
          res.drill.thumbnailUrl,
          drill.skills,
          drill.videoUrl);
    } catch (e) {
      rethrow;
      //TODO: error handling
    }
    return drill;
  }
}
