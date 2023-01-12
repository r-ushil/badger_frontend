
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';

import 'api_client_channel.dart';
import 'badger-api/leaderboard/v1/leaderboard.pb.dart';
import 'badger-api/leaderboard/v1/leaderboard_api.pbgrpc.dart';


class TopPlayersModel {

  static final topPlayersServiceClient = LeaderboardServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static Future<List<Player>> getTopPlayers(int noPlayers) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final req = GetTopPlayersRequest();
    try {
      final res = await topPlayersServiceClient.getTopPlayers(req,
          options: CallOptions(metadata: {"authorization": uid}));
      
      return res.topPlayers;
    } catch (e) {
      rethrow;
    }
  }

}