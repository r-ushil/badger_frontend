import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dashboard/view-model/dashboard_view_model.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({Key? key, required this.metricName}) : super(key: key);

  final String metricName;

  @override
  Widget build(BuildContext context) {

    return Container(
      //width: 80,
      height: 25,
      padding: const EdgeInsets.only(left: 2.0, right: 5.0),
      decoration: BoxDecoration(
          color: getMetricColour(metricName),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              Icon(getMetricIcon(metricName), color: Colors.white),
              Text(
                metricName,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

getMetricIcon(String metricName) {
  switch (metricName) {
    case "Batting":
      return Icons.sports_cricket;
    case "Fielding":
      return Icons.sports_handball;
    case "Bowling":
      return Icons.speed;
  }
}

getMetricColour(String metricName) {
  switch (metricName) {
    case "Batting":
      return const Color(0xffff7d03);
    case "Fielding":
      return const Color(0xffa05dc7);
    case "Bowling":
      return const Color(0xff00d9dd);

  }
}
