import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../api_models/total_submissions.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class MetricData {
  MetricData(this.name, this.score, this.submissions, this.icon, this.color);

  final String name;
  final int score;
  final int submissions;
  final IconData icon;
  final Color color;
}

class DashboardViewModel {
  DashboardViewModel();

  static Future<SubmissionStatistics> getStats() {
    return SubmissionStatsModel.getSubmissionStats();
  }

  static Future<List<MetricData>> getMetrics() async {
    final submissionStats = await getStats();

    return [
      MetricData("Batting", submissionStats.battingScore, submissionStats.battingSubmissions,
        Icons.sports_cricket, const Color(0xffff7d03)),
      MetricData("Fielding", submissionStats.fieldingScore, submissionStats.fieldingSubmissions,
        Icons.sports_handball, const Color(0xffa05dc7)),
      MetricData("Bowling", submissionStats.bowlingScore, submissionStats.bowlingSubmissions,
        Icons.speed,const Color(0xff00d9dd)),
    ];
  }
}
