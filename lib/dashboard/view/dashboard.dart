import 'package:badger_frontend/common/auth/auth_model.dart';
import 'package:badger_frontend/dashboard/leaderboard.dart';
import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api_models/name_model.dart';
import '../../drill_list/view/drill_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<BadgerAuth>(context);

    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 50),
                    width: (MediaQuery.of(context).size.width - 30) / 2,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          backgroundColor: Colors.green.withOpacity(0.5),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Overview"))),
                Container(
                    margin: const EdgeInsets.only(right: 10, top: 50),
                    width: (MediaQuery.of(context).size.width - 20) / 2,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Leaderboard()));
                        },
                        style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 3),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        child: const Text("Leaderboard"))),
              ],
            ),
            const SizedBox(width: 20, height: 20,),
            const Text("Submissions", style: TextStyle(fontSize: 20)),
            const MetricChart(),
            const SizedBox(width: 20, height: 20,),
            const Text("Average Scores", style: TextStyle(fontSize: 20)),
            const SizedBox(width: 20, height: 20,),
            const Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: MetricProgressBars()),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                showNameChangeDialog(context);
              },
              child: const Text("Change Name"),
            )
          ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle, size: 60),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const DrillList())); //TODO: change implementation
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(64, 235, 133, 50),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.home, color: Colors.white)),
                IconButton(
                    onPressed: () async {
                      await auth.logout();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white)),
              ])),
    );
  }
}

showNameChangeDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  String name = '';

  Widget submitButton = TextButton(
    child: const Text("Submit", style: TextStyle(color: Colors.blue)),
    onPressed: () async {
      await NameModel.setName(name);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    },
  );

  Widget backButton = TextButton(
    child: const Text("Back", style: TextStyle(color: Colors.blue)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Enter your name here"),
    content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter your name here: ',
        ),
        onChanged: (text) {
          name = text;
        }),
    actions: [submitButton, backButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
