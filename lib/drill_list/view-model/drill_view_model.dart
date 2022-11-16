import 'package:flutter/material.dart';
import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:provider/provider.dart';

class DrillData {
  //todo - replace with builder pattern for better readability
  DrillData(this.name, this.metricNames, this.timeTaken, this.thumbnail,
      this.videoUrl, this.description);

  final String name;
  final List<String> metricNames;
  final int timeTaken;
  final Image thumbnail;
  final String videoUrl;
  final String description;
}

// create drill view model
class DrillViewModel {
  Color getMetricColor(String metricname, context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final metricData = dashboardViewModel.getMetrics();
    for (MetricData m in metricData) {
      if (metricname.compareTo(m.name) == 0) {
        return m.color;
      }
    }
    return Colors.red;
  }

  Icon getMetricIcon(String metricname, context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final metricData = dashboardViewModel.getMetrics();
    for (MetricData m in metricData) {
      if (metricname.compareTo(m.name) == 0) {
        return Icon(m.icon, color: Colors.white);
      }
    }
    return const Icon(Icons.error, color: Colors.red);
  }
}
