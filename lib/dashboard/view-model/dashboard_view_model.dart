import 'package:flutter/material.dart';

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
    MetricData(
        "Power", 15, Icons.local_fire_department, const Color(0xffff7d03)),
    MetricData("Timing", 25, Icons.timer, const Color(0xffa05dc7)),
    MetricData("Reaction Time", 15, Icons.flash_on, const Color(0xff8dfe00)),
    MetricData("Agility", 25, Icons.directions_run, const Color(0xff00d9dd)),
    MetricData("Hand Speed", 20, Icons.speed, const Color(0xfff70403))
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
    // TODO: replace with api call handling
    return 65;
  }

  getProfilePicture() {
    // TODO: replace with api call handling
    return Image.asset("images/profilepic.png", height: 170, width: 170);
  }
}
