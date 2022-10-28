import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget _buildDrillButton(
      BuildContext context, String name, String description) {
    return Container(
        padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Center(child: Text(name)),
                        titleTextStyle:
                            const TextStyle(fontSize: 40, color: Colors.black),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.cancel),
                                color: Colors.red,
                                iconSize: 60,
                              ),
                              IconButton(
                                  onPressed: () => {
                                        Navigator.pushNamed(
                                            context, '/drillInstructions',
                                            arguments: name)
                                      },
                                  icon: const Icon(Icons.next_plan),
                                  color: Colors.green,
                                  iconSize: 60)
                            ],
                          )
                        ]),
                      ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                textStyle: const TextStyle(fontSize: 30),
                minimumSize: const Size(0, 60)),
            child: Text(name)));
  }

  @override
  Widget build(BuildContext context) {
    Widget title = const Padding(
      padding: EdgeInsets.all(32),
      child: Text('Drills',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badger'),
        backgroundColor: Colors.red[200],
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/performanceOverview');
            },
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: Column(
        children: [
          title,
          Expanded(
              child: ListView(
            children: [
              _buildDrillButton(context, "Speed of Light",
                  "This is a drill to test reaction speed"),
              _buildDrillButton(
                  context, "Drill1", "This is the description of the drill"),
              _buildDrillButton(
                  context, "Drill2", "This is the description of the drill"),
              _buildDrillButton(
                  context, "Drill3", "This is the description of the drill"),
              _buildDrillButton(
                  context, "Drill4", "This is the description of the drill"),
              _buildDrillButton(
                  context, "Drill5", "This is the description of the drill"),
              _buildDrillButton(
                  context, "Drill6", "This is the description of the drill"),
              _buildDrillButton(
                  context, "Drill7", "This is the description of the drill"),
            ],
          ))
        ],
      ),
    );
  }
}
