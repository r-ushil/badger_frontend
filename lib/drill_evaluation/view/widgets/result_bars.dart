import 'package:badger_frontend/drill_evaluation/view-model/drill_evaluation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../dashboard/view/widgets/progress_bars.dart';

class ResultBars extends StatelessWidget {
  const ResultBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drillEvalViewModel = Provider.of<DrillEvaluationViewModel>(context);
    final metricData = drillEvalViewModel.getMetrics();

    return Column(
      children: [
        for (var metric in metricData)
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProgressBarWithText(
                    metricName: metric.name,
                    icon: Icon(metric.icon, color: metric.color),
                    value: metric.score, // TODO
                    color: metric.color,
                    width: 100,
                  ),
                  drillEvalViewModel.chooseArrow(metric),
                  drillEvalViewModel.getImprovement(metric),
                ],
              )),
      ],
    );
  }
}
