import 'package:badger_frontend/api_models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
final user = PersonModel.getPersonData(userId);

class MetricData {
  MetricData(this.name, this.score, this.icon, this.color);

  final String name;
  final int score;
  final IconData icon;
  final Color color;
}

class DashboardViewModel {
  DashboardViewModel();

  static final List<MetricData> metrics = [
    MetricData("Power", getPowerScore(), Icons.local_fire_department,
        const Color(0xffff7d03)),
    MetricData(
        "Timing", getTimingScore(), Icons.timer, const Color(0xffa05dc7)),
    MetricData("Agility", getAgilityScore(), Icons.directions_run,
        const Color(0xff00d9dd)),
  ];

  MetricData? getMetric(String name) {
    for (MetricData m in metrics) {
      if (name.compareTo(m.name) == 0) {
        return m;
      }
    }
    return null;
  }

  int getTotalScore() {
    return user.totalScore;
  }

  getProfilePicture() {
    // TODO: replace with api call handling
    return Image.asset("images/profilepic.png", height: 170, width: 170);
  }

  int getPowerScore() {
    return user.powerScore;
  }

  int getTimingScore() {
    return user.timingScore;
  }

  int getAgilityScore() {
    return user.agilityScore;
  }
}
