import 'package:badger_frontend/badger-api/drill/v1/drill_instructions.pb.dart';
import 'package:badger_frontend/badger-api/drill/v1/drill_api.pbgrpc.dart';
import 'package:badger_frontend/drill_list/model/api_client_channel.dart';
import 'package:grpc/grpc.dart';

//classes directly representing backend implementations
class DrillModelData {
  final String drillId;
  final String drillName;
  final String drillDescription;

  DrillModelData(this.drillId, this.drillName, this.drillDescription);
}

class DrillInstructionData {
  final String instruction;
  final List<DrillInstructionStepData> steps;

  DrillInstructionData(this.instruction, this.steps);
}
//TODO: check how data is found (id?)

class DrillInstructionStepData {
  final String title;
  final String description;
  final String mediaUrl;
  //TODO: add thumbnailUrl
  final MediaTypeData mediaType;

  DrillInstructionStepData(
      this.title, this.description, this.mediaUrl, this.mediaType);
}

enum MediaTypeData { mediaTypeUnspecified, mediaTypeVideo, mediaTypeImage }

MediaTypeData toMediaTypeData(MediaType mt) {
  switch (mt) {
    case MediaType.MEDIA_TYPE_UNSPECIFIED:
      return MediaTypeData.mediaTypeUnspecified;
    case MediaType.MEDIA_TYPE_VIDEO:
      return MediaTypeData.mediaTypeVideo;
    case MediaType.MEDIA_TYPE_IMAGE:
      return MediaTypeData.mediaTypeImage;
    default:
      throw Error(); //TODO: improve error handling
  }
}

class DrillModel {
  static final drillServiceClient = DrillServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static Future<List<DrillModelData>> getDrillsData() async {
    List<DrillModelData> drills = List.empty(growable: false);
    final req = GetDrillsRequest();
    try {
      final res = await drillServiceClient.getDrills(req);
      drills = res.drills
          .map((drill) => DrillModelData(
              drill.drillId, drill.drillName, drill.drillDescription))
          .toList();
    } catch (e) {
      print("Error");
      print(e); //TODO: error handling
    }
    return drills;
  }

  static Future<DrillModelData> getDrillData(String drillId) async {
    final req = GetDrillRequest(drillId: drillId);
    DrillModelData drill = DrillModelData("0", "dummy", "dummy");
    try {
      final res = await drillServiceClient.getDrill(req);
      drill = DrillModelData(
          res.drill.drillId, res.drill.drillName, res.drill.drillDescription);
    } catch (e) {
      print("Error");
      print(e); //TODO: error handling
    }
    return drill;
  }

  static Future<DrillInstructionData> getDrillInstructionData(
      String drillId) async {
    final req = GetDrillInstructionsRequest(drillId: drillId);
    DrillInstructionData drillInstructions =
        DrillInstructionData("dummy", List.empty());
    try {
      final res = await drillServiceClient.getDrillInstructions(req);
      final drillInstructionSteps = res.drillInstructions.steps
          .map((step) => DrillInstructionStepData(step.title, step.description,
              step.mediaUrl, toMediaTypeData(step.mediaType)))
          .toList(growable: false);
      drillInstructions = DrillInstructionData(
          res.drillInstructions.introduction, drillInstructionSteps);
    } catch (e) {
      print("Error");
      print(e); //TODO: error handling
    }
    return drillInstructions;
  }
}
