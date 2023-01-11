import 'package:badger_frontend/api_models/drill_submission_model.dart';
import 'package:badger_frontend/api_models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
UserScoreData? userScores;

class MetricData {
  MetricData(this.name, this.score, this.icon, this.color);

  final String name;
  final double score;
  final IconData icon;
  final Color color;
}

class DashboardViewModel {
  DashboardViewModel();

  static void getUserScoreData() async {
    userScores = await DrillSubmissionModel.getUserScoreData(userId);
  }

  static final dummyMetrics = [
    MetricData("Power", 100, Icons.local_fire_department,
        const Color(0xffff7d03)),
    MetricData(
        "Timing", 100, Icons.timer, const Color(0xffa05dc7)),
    MetricData("Agility", 100, Icons.directions_run,
        const Color(0xff00d9dd)),
    ];

  static Future<List<MetricData>> getMetrics() async { 
    return [
    MetricData("Cover Drive", userScores!.coverDriveScore, Icons.local_fire_department,
        const Color(0xffff7d03)),
    MetricData(
        "Katchet Board Catch", userScores!.katchetBoardScore, Icons.timer, const Color(0xffa05dc7)),
    ];
  }

  MetricData? getMetric(String name) {
    for (MetricData m in dummyMetrics) {
      if (name.compareTo(m.name) == 0) {
        return m;
      }
    }
    return null;
  }

  getProfilePicture() {
    // TODO: replace with api call handling
    return Image.asset("images/profilepic.png", height: 170, width: 170);
  }

}
