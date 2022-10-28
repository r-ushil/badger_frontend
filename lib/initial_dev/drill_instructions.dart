import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';

class DrillInstructions extends StatelessWidget {
  const DrillInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badger'),
        backgroundColor: Colors.red[200],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
              child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('Record',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60)),
          )),
          Center(
            child: Text(
              ModalRoute.of(context)!.settings.arguments as String,
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const Expanded(
              child: Padding(
                  padding: EdgeInsets.all(32),
                  child: BulletedList(
                    listItems: [
                      "Instruction one",
                      "Instruction two",
                      "Instruction three three three three three three three",
                    ],
                    style: TextStyle(fontSize: 25, color: Colors.black),
                    bulletColor: Colors.black,
                  ))),
          Container(
              padding: const EdgeInsets.only(bottom: 15),
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/takeVideo',
                        arguments: ModalRoute.of(context)!.settings.arguments
                            as String);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      textStyle: const TextStyle(fontSize: 30),
                      minimumSize: const Size(0, 60)),
                  child: const Text('Go')))
        ],
      ),
    );
  }
}
