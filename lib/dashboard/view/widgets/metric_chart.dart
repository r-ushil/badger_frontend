import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricChart extends StatefulWidget {
  const MetricChart({super.key});

  @override
  State<MetricChart> createState() => _MetricChart();
}

class _MetricChart extends State<MetricChart> {
  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final metricData = DashboardViewModel.getMetrics();
    final profpic = dashboardViewModel.getProfilePicture();

    return FutureBuilder<List<MetricData>>(
        future: metricData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SfCircularChart(series: <CircularSeries>[
              // Render pie chart
              DoughnutSeries<MetricData, String>(
                  dataSource: snapshot.data,
                  xValueMapper: (MetricData data, _) => data.name,
                  yValueMapper: (MetricData data, _) => data.score,
                  innerRadius: '70%',
                  explode: false,
                  dataLabelMapper: (MetricData data, _) => "${data.score}",
                  pointColorMapper: (MetricData data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    useSeriesColor: true,
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  animationDuration: 1000)
            ], annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: profpic,
              )
            ]);
          }
          return Center(
            child: Column(
              children: const <Widget>[
              SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Colors.white)),
              ],
            ),
          );
        });
  }
}
