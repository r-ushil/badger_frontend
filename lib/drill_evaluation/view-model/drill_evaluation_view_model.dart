import 'package:flutter/material.dart';

import '../../dashboard/view-model/dashboard_view_model.dart';

class DrillEvaluationViewModel {
  DrillEvaluationViewModel();

  List<MetricData> getMetrics() {
    // TODO: replace with api call handling
    return [
      MetricData(
          "Power", 15, Icons.local_fire_department, const Color(0xffff7d03)),
      MetricData("Timing", 25, Icons.timer, const Color(0xffa05dc7)),
    ];
  }

  int getTotalScore() {
    return 40;
  }

  Icon chooseArrow(MetricData metric) {
    int yourAvg = 20; // TODO
    bool isImproved = metric.score >= yourAvg;

    if (isImproved) {
      return const Icon(Icons.arrow_drop_up, color: Colors.green, size: 30);
    }
    return const Icon(Icons.arrow_drop_down, color: Colors.red, size: 30);
  }

  Text getImprovement(MetricData metric) {
    int yourAvg = 20; // TODO
    int improvement = metric.score - yourAvg;
    String output = "$improvement%";

    return Text(output,
        style: TextStyle(
            fontSize: 20,
            color: (improvement < 0) ? Colors.red : Colors.green));
  }
}
