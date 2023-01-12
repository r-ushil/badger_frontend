import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MetricChart extends StatefulWidget {
  const MetricChart({super.key});

  @override
  State<MetricChart> createState() => _MetricChart();
}

class _MetricChart extends State<MetricChart> {
  @override
  Widget build(BuildContext context) {
    final metrics = DashboardViewModel.getMetrics();

    return FutureBuilder<List<MetricData>>(
        future: metrics,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int totalSubmissions =
                getTotalSubmissions(snapshot.data!);

            if (totalSubmissions == 0) {
              return Center(
                child: Column(
                  children: const <Widget>[
                    SizedBox(
                        width: 60,
                        height: 60),
                    Text(
                      "Complete you first drill to see some submission statistics!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                    SizedBox(
                        width: 60,
                        height: 250),
                  ],
                ),
              );
            } else {
              return SfCircularChart(series: <CircularSeries>[
                // Render pie chart
                DoughnutSeries<MetricData, String>(
                    dataSource: snapshot.data,
                    xValueMapper: (MetricData data, _) => data.name,
                    yValueMapper: (MetricData data, _) => data.submissions,
                    innerRadius: '70%',
                    explode: false,
                    dataLabelMapper: (MetricData data, _) => "${data.submissions}",
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
                  widget: Text(totalSubmissions.toString()),
                )
              ]);
            }
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

int getTotalSubmissions(List<MetricData> metrics) {
  int total = 0;
  for (final metric in metrics) {
    total += metric.submissions;
  }
  return total;
}
