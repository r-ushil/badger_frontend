import 'package:flutter/material.dart';
import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:provider/provider.dart';

class DrillData {
  //todo - replace with builder pattern for better readability
  DrillData(this.name, this.metricname, this.timeTaken, this.thumbnail,
      this.videoUrl, this.description);

  final String name;
  final String metricname;
  final int timeTaken;
  final Image thumbnail;
  final String videoUrl;
  final String description;
}

// create drill view model
class DrillViewModel {
  List<DrillData> getDrillData() {
    // to replace with api call handling
    return [
      DrillData(
          "Sprint",
          "Agility",
          1,
          Image.network(
              "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg",
          ),
          "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
          "Sprint back and forth between two cones 5 times as quickly as you can!"),
      DrillData(
          "Sprint",
          "Agility",
          1,
          Image.network(
            "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg",
          ),
          "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
          "Sprint back and forth between two cones 5 times as quickly as you can!"),
      DrillData(
          "Sprint",
          "Agility",
          1,
          Image.network(
            "https://post.healthline.com/wp-content/uploads/2021/04/Cone-Fitness-Male-Gym-1200x628-Facebook.jpg",
          ),
          "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
          "Sprint back and forth between two cones 5 times as quickly as you can!"),
    ];
  }

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
