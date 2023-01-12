import 'package:firebase_auth/firebase_auth.dart';
import 'package:grpc/grpc.dart';
import 'api_client_channel.dart';
import 'badger-api/leaderboard/v1/leaderboard_api.pbgrpc.dart';

class SubmissionStatistics {
  int battingScore;
  int fieldingScore;
  int bowlingScore;
  int battingSubmissions;
  int fieldingSubmissions;
  int bowlingSubmissions;

  SubmissionStatistics(
      {required this.battingScore,
      required this.fieldingScore,
      required this.bowlingScore,
      required this.battingSubmissions,
      required this.fieldingSubmissions,
      required this.bowlingSubmissions});
}

class SubmissionStatsModel {
  static final submissionStatsServiceClient = LeaderboardServiceClient(
      ApiClientChannel.getClientChannel(),
      options: CallOptions(timeout: const Duration(minutes: 1)));

  static Future<SubmissionStatistics> getSubmissionStats() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final req = GetMyScoreRequest();
    try {
      final res = await submissionStatsServiceClient.getMyScore(req,
          options: CallOptions(metadata: {"authorization": uid}));
      final stats = SubmissionStatistics(
          battingScore: res.battingScore,
          fieldingScore: res.catchingScore,
          bowlingScore: res.bowlingScore,
          battingSubmissions: res.totalBattingSubmissions,
          fieldingSubmissions: res.totalCatchingSubmissions,
          bowlingSubmissions: res.totalBowlingSubmissions);
      return stats;
    } catch (e) {
      rethrow;
    }
  }
}
