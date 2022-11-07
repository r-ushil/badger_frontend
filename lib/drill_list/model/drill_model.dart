import 'package:badger_frontend/badger-api/drill/v1/drill_instructions.pb.dart';
//import 'package:flutter/material.dart';
//import 'drills.dart' as $drills_api;
//import 'package:protobuf/protobuf.dart' as $pb;
import 'package:badger_frontend/badger-api/drill/v1/drill_api.pbgrpc.dart';
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

class DisplayableDrill {
  //todo - replace with builder pattern for better readability
  DisplayableDrill(
      this.name, this.thumbnailUrl, this.mediaUrl, this.description);

  final String name;
  final String thumbnailUrl;
  final String mediaUrl;
  final String description;
}

class DrillModel {
  static DisplayableDrill toDisplayableDrill(DrillInstructionStepData step) {
    return DisplayableDrill(
        step.title,
        "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg",
        step.mediaUrl,
        step.description);
  }

  static Future<List<DisplayableDrill>> getDrillData(String id) async {
    print("here1");
    final clientChannel = ClientChannel('0.0.0.0',
        port: 3000, // TODO: Extract to environment variable
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    print("here2");
    final drillServiceClient = DrillServiceClient(clientChannel,
        options: CallOptions(timeout: const Duration(minutes: 1)));
    print("here3");
    List<DisplayableDrill> drillDataSteps = List.empty(growable: true);

    final req = GetDrillRequest(drillId: id);
    final instrReq = GetDrillInstructionsRequest(drillId: id);
    print("here4");
    try {
      final drill = await drillServiceClient.getDrill(req).then((res) =>
          DrillModelData(res.drill.drillId, res.drill.drillName,
              res.drill.drillDescription));
      print("got Drill");
      final drillInstructions = await drillServiceClient
          .getDrillInstructions(instrReq)
          .then((res) => DrillInstructionData(
              res.drillInstructions.introduction,
              res.drillInstructions.steps
                  .map((s) => DrillInstructionStepData(s.title, s.description,
                      s.mediaUrl, toMediaTypeData(s.mediaType)))
                  .toList(growable: false)));
      print("got drill instrs");
      for (var drillStep in drillInstructions.steps) {
        drillDataSteps.add(toDisplayableDrill(drillStep));
      }
    } catch (e) {
      print("Error");
      print(e); //TODO: error handling
    }
    return drillDataSteps;
  }
}

// Icon matchIcon() {
//   //TODO: switch statement matching drill ids to icons
//   return const Icon(Icons.flash_on);
// }

// Image matchThumbnail() {
//   //TODO: switch statement fetching thumbnail
//   return Image.network(
//       "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg");
// }
