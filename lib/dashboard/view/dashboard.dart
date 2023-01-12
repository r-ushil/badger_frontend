import 'package:badger_frontend/common/auth/auth_model.dart';
import 'package:badger_frontend/dashboard/view/widgets/metric_chart.dart';
import 'package:badger_frontend/dashboard/view/widgets/progress_bars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    width: (MediaQuery.of(context).size.width - 20) / 2,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Overview"))),
                Container(
                    margin: const EdgeInsets.only(right: 10, top: 50),
                    width: (MediaQuery.of(context).size.width - 20) / 2,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 3),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            backgroundColor: Colors.green.withOpacity(0.5),
                            foregroundColor: Colors.white),
                        child: const Text("Leaderboard"))),
              ],
            ),
            const MetricChart(),
            const Padding(
                padding: EdgeInsets.only(left: 40.0),
                child: MetricProgressBars()),
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
