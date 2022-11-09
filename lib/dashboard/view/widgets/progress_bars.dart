import 'package:badger_frontend/dashboard/view-model/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class MetricProgressBars extends StatelessWidget {
  const MetricProgressBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DashboardViewModel>(context);
    final metricData = dashboardViewModel.getMetrics();

    return Column(
      children: [
        for (var metric in metricData)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ProgressBarWithText(
                metricName: metric.name,
                icon: Icon(metric.icon, color: metric.color),
                value: metric.score,
                color: metric.color),
          ),
      ],
    );
  }
}

class ProgressBarWithText extends StatelessWidget {
  final String metricName;
  final Icon icon;
  final int value;
  final Color color;

  const ProgressBarWithText({
    Key? key,
    required this.metricName,
    required this.value,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
            child: icon, //icon
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
            child: LinearPercentIndicator(
              // bar
              percent: value / 100,
              width: MediaQuery.of(context).size.width * 0.45,
              lineHeight: 10,
              animation: true,
              progressColor: color,
              backgroundColor: const Color(0xFF1F1F1F),
              barRadius: const Radius.circular(10),
              padding: EdgeInsets.zero,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
            child: SelectionArea(
                child: Text(
              // name
              metricName,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            )),
          ),
        ],
      ),
    );
  }
}
