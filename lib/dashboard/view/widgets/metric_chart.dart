import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricChart extends StatelessWidget {
  const MetricChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final metricData = dashboardViewModel.getMetrics();
    final totalScore = dashboardViewModel.getTotalScore();

    return SfCircularChart(series: <CircularSeries>[
      // Render pie chart
      DoughnutSeries<MetricData, String>(
          dataSource: metricData,
          xValueMapper: (MetricData data, _) => data.name,
          yValueMapper: (MetricData data, _) => data.score,
          innerRadius: '70%',
          explode: false,
          dataLabelMapper: (MetricData data, _) =>
              "${data.name}: ${data.score}",
          animationDuration: 1000)
    ], annotations: <CircularChartAnnotation>[
      CircularChartAnnotation(
          widget: Text(
        '$totalScore',
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 64, fontFamily: 'Segoe UI'),
      ))
    ]);
  }
}
