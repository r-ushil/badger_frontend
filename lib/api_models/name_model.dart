import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';

import 'api_client_channel.dart';
import 'badger-api/leaderboard/v1/leaderboard_api.pbgrpc.dart';

class NameModel {
  static final nameServiceClient = LeaderboardServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static Future<String> getName() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final req = GetMyPublicNameRequest();
    try {
      final res = await nameServiceClient.getMyPublicName(req,
          options: CallOptions(metadata: {"authorization": uid}));
      return res.name;
    } catch (e) {
      rethrow;
    }
  }

  static setName(String name) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final req = SetMyPublicNameRequest(name: name);
    try {
      await nameServiceClient.setMyPublicName(req,
          options: CallOptions(metadata: {"authorization": uid}));
    } catch (e) {
      rethrow;
    }
  }  
  
}
