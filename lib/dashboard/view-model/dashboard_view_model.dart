import 'package:badger_frontend/api_models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;

class MetricData {
  MetricData(this.name, this.score, this.icon, this.color);

  final String name;
  final int score;
  final IconData icon;
  final Color color;
}

class DashboardViewModel {
  DashboardViewModel();

  Future<int> getTotalScore() async {
    try {
      final user = await PersonModel.getPersonData(userId);
      return user.userScore;
    } catch (e) {
      rethrow;
    }
  }

  getProfilePicture() {
    // TODO: replace with api call handling
    return Image.asset("images/profilepic.png", height: 170, width: 170);
  }

  static Future<List<MetricData>> getMetrics() async {
    try {
      final user = await PersonModel.getPersonData(userId);
      final metrics = [
        MetricData("Power", user.userPowerScore, Icons.local_fire_department,
            const Color(0xffff7d03)),
        MetricData("Timing", user.userTimingScore, Icons.timer,
            const Color(0xffa05dc7)),
        MetricData("Agility", user.userAgilityScore, Icons.directions_run,
            const Color(0xff00d9dd))
      ];
      return metrics;
    } catch (e) {
      rethrow;
    }
  }
}
