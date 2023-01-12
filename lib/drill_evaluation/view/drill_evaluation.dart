import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/drill_evaluation/view/widgets/result_bars.dart';
import 'package:badger_frontend/drill_evaluation/view/widgets/result_tile.dart';
import 'package:badger_frontend/drill_evaluation/view/widgets/small_button.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/header.dart';

import '../../api_models/drill_submission_model.dart';

class DrillEvaluation extends StatefulWidget {
  const DrillEvaluation({Key? key, required this.drillSubmissionId})
      : super(key: key);

  final String drillSubmissionId;

  @override
  State<DrillEvaluation> createState() => _DrillEvaluationState();
}

class _DrillEvaluationState extends State<DrillEvaluation> {
  @override
  Widget build(BuildContext context) {
    var drillScoreFuture = DrillSubmissionModel.subscribeToDrillSubmission(
            widget.drillSubmissionId)
        .first;

    return FutureBuilder(
        future: drillScoreFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var totalScore = snapshot.requireData.drillScore;
            var advice1 = snapshot.requireData.advice1;
            var advice2 = snapshot.requireData.advice2;
            return Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.green,
                  elevation: 0,
                  title: const Center(child: Text("Results"))),
              body: Center(
                  child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.green,
                        height: 50,
                      ),
                      Center(
                          child: Container(
                              width: 150,
                              height: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(59, 59, 59, 1.0),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(10, 121, 6, 1.0),
                                      width: 5),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Your score",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Header(totalScore.toString()),
                                ],
                              )))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Feedback from your upload:",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        Text("• $advice1",
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("• $advice2",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SmallButton("Drill selection", false, gotoDrillList)
                      ])
                ],
              )),
              bottomNavigationBar: BottomAppBar(
                  color: const Color.fromRGBO(64, 235, 133, 50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dashboard()));
                            },
                            icon: const Icon(Icons.home, color: Colors.white)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.logout,
                                color: Colors.white)),
                      ])),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }

  void gotoDrillList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DrillList()));
  }
}
