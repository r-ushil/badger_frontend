import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dashboard/view-model/dashboard_view_model.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({Key? key, required this.metricName}) : super(key: key);

  final String metricName;

  @override
  Widget build(BuildContext context) {
    var dashboardViewModel = Provider.of<DashboardViewModel>(context);
    var metric = dashboardViewModel.getMetric(metricName)!;

    return Container(
      //width: 80,
      height: 25,
      padding: const EdgeInsets.only(left: 2.0, right: 5.0),
      decoration: BoxDecoration(
          color: metric.color,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              Icon(metric.icon, color: Colors.white),
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
