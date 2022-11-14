import 'package:badger_frontend/ar/view/ar.dart';
import 'package:badger_frontend/drill_list/view-model/drill_view_model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({Key? key, required this.metricName}) : super(key: key);

  final String metricName;

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = Provider.of<DrillViewModel>(context);
    final metricIcon = dashboardViewModel.getMetricIcon(metricName, context);
    final metricColor = dashboardViewModel.getMetricColor(metricName, context);

    return Container(
      width: 80,
      height: 25,
      padding: const EdgeInsets.only(left: 2.0),
      decoration: BoxDecoration(
          color: metricColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Row(
            children: [
              metricIcon,
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
