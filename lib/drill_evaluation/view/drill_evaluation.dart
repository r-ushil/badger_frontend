import 'package:badger_frontend/dashboard/view/dashboard.dart';
import 'package:badger_frontend/drill_evaluation/view/widgets/result_bars.dart';
import 'package:badger_frontend/drill_evaluation/view/widgets/result_tile.dart';
import 'package:badger_frontend/drill_evaluation/view/widgets/small_button.dart';
import 'package:badger_frontend/drill_list/view/drill_list.dart';
import 'package:flutter/material.dart';
import 'package:badger_frontend/auth/view/widgets/header.dart';
import 'package:provider/provider.dart';

import '../view-model/drill_evaluation_view_model.dart';

class DrillEvaluation extends StatefulWidget {
  const DrillEvaluation({Key? key}) : super(key: key);

  @override
  State<DrillEvaluation> createState() => _DrillEvaluationState();
}

class _DrillEvaluationState extends State<DrillEvaluation> {
  @override
  Widget build(BuildContext context) {
    final drillEvalViewModel = Provider.of<DrillEvaluationViewModel>(context);
    final totalScore = drillEvalViewModel.getTotalScore().toString();

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
                              color: const Color.fromRGBO(10, 121, 6, 1.0),
                              width: 5),
                          borderRadius: BorderRadius.circular(100)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Your score",
                            style: TextStyle(fontSize: 20),
                          ),
                          Header(totalScore),
                        ],
                      )))
            ],
          ),
          // HERE
          const SizedBox(
            height: 20,
          ),
          Container(
              width: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white12,
                border: Border.all(color: Colors.green, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ResultBars()),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Feedback from your upload:",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 250,
            child: Column(
              children: const [
                Text("• this is a feedback, ", style: TextStyle(fontSize: 20)),
                Text("• this is another feedback, ",
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const ResultTile(isImproved: true), // TODO
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SmallButton("Retry", true, retry),
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
                    icon: const Icon(Icons.star, color: Colors.white)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.people, color: Colors.white)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings, color: Colors.white)),
              ])),
    );
  }

  Future<void> retry() async {
    //TODO: navigate to record video screen
  }

  void gotoDrillList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DrillList()));
  }
}
