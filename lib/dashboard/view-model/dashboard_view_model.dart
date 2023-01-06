import 'package:badger_frontend/api_models/person_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
PersonData? user;

class MetricData {
  MetricData(this.name, this.score, this.icon, this.color);

  final String name;
  final int score;
  final IconData icon;
  final Color color;
}

class DashboardViewModel {
  DashboardViewModel();

  static Future<PersonData> getUser() {
    return PersonModel.getPersonData(userId);
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
    final powerScore = await getPowerScore(); 
    final timingScore = await getTimingScore(); 
    final agilityScore = await getAgilityScore(); 
    return [
    MetricData("Power", powerScore, Icons.local_fire_department,
        const Color(0xffff7d03)),
    MetricData(
        "Timing", timingScore, Icons.timer, const Color(0xffa05dc7)),
    MetricData("Agility", agilityScore, Icons.directions_run,
        const Color(0xff00d9dd)),
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

  static Future<int> getPowerScore() async {
    user = await getUser();
    return user!.userPowerScore;
  }
  static Future<int> getTimingScore() async {
    user = await getUser();
    return user!.userTimingScore;
  }
  static Future<int> getAgilityScore() async {
    user = await getUser();
    return user!.userAgilityScore;
  }

  getProfilePicture() {
    // TODO: replace with api call handling
    return Image.asset("images/profilepic.png", height: 170, width: 170);
  }

}
